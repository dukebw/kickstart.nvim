local M = {}

local state = {
  projects = {},
  capabilities = nil,
  preflight = {},
  restart_attempts = {},
}

local function normalize(path)
  if not path or path == '' then
    return nil
  end
  return vim.loop.fs_realpath(path) or path
end

local function starts_with(path, prefix)
  return path == prefix or vim.startswith(path, prefix .. '/')
end

local function contains(list, value)
  return vim.tbl_contains(list or {}, value)
end

local function basename(path)
  return vim.fs.basename(path:gsub('/$', ''))
end

local function buf_path(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' or name:match '^%a+://' then
    return nil
  end
  return normalize(name)
end

local function project_root(bufnr, project)
  local path = buf_path(bufnr)
  if not path then
    return nil
  end

  local root = vim.fs.root(bufnr, project.root_markers or { '.git', 'compile_commands.json', '.clangd' })
  root = normalize(root or vim.fs.dirname(path))

  if root and starts_with(root, normalize(project.local_prefix)) then
    return root
  end

  return nil
end

local function remote_root_for(project, root)
  local local_prefix = normalize(project.local_prefix)
  local suffix = root:sub(#local_prefix + 1)
  if suffix == '' then
    suffix = '/' .. basename(root)
  end
  return (project.remote_prefix:gsub('/$', '')) .. suffix
end

local function match_buffer(bufnr)
  local filetype = vim.bo[bufnr].filetype
  local path = buf_path(bufnr)
  if not path then
    return nil
  end

  for _, project in ipairs(state.projects) do
    local local_prefix = normalize(project.local_prefix)
    if contains(project.filetypes or { 'cuda' }, filetype) and local_prefix and starts_with(path, local_prefix) then
      local root = project_root(bufnr, project)
      if root then
        return project, root, remote_root_for(project, root)
      end
    end
  end

  return nil
end

function M.should_handle_buffer(bufnr)
  return match_buffer(bufnr or 0) ~= nil
end

local function client_name(project)
  return 'remote_clangd_' .. (project.name or 'default')
end

local function start_client(bufnr, project, root, remote_root)
  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end

  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr, name = client_name(project) }) do
    if client.config.root_dir == root then
      return
    end
  end

  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr, name = 'clangd' }) do
    vim.lsp.buf_detach_client(bufnr, client.id)
  end

  vim.lsp.start({
    name = client_name(project),
    cmd = {
      project.wrapper or (vim.fn.expand '~/.local/bin/remote-clangd'),
      '--local-root',
      root,
      '--remote-root',
      remote_root,
      '--ssh-alias',
      project.ssh_alias,
      '--clangd',
      project.clangd or 'clangd-21',
      '--compiler',
      project.compiler or 'clang++-21',
      '--cuda-arch',
      project.cuda_arch or 'sm_100a',
      '--cuda-path',
      project.cuda_path or '/usr/local/cuda',
    },
    root_dir = root,
    capabilities = state.capabilities,
  }, { bufnr = bufnr })
end

local function start_after_preflight(bufnr, project, root, remote_root)
  local key = (project.name or 'default') .. ':' .. root

  if project.preflight == false or state.preflight[key] == 'done' or vim.fn.executable 'rexec' ~= 1 then
    start_client(bufnr, project, root, remote_root)
    return
  end

  if state.preflight[key] == 'running' then
    vim.defer_fn(function()
      local matched_project, matched_root, matched_remote_root = match_buffer(bufnr)
      if matched_project and matched_root == root then
        start_after_preflight(bufnr, matched_project, matched_root, matched_remote_root)
      end
    end, 500)
    return
  end

  state.preflight[key] = 'running'

  vim.system({ 'rexec', '--flush', '--quiet', 'true' }, {
    env = {
      REXEC_LOCAL_ROOT = root,
      REXEC_WORKDIR = remote_root,
    },
    text = true,
  }, function(result)
    vim.schedule(function()
      if result.code == 0 then
        state.preflight[key] = 'done'
        start_client(bufnr, project, root, remote_root)
        return
      end

      state.preflight[key] = nil
      vim.notify(
        string.format('remote clangd preflight failed for %s: %s', root, result.stderr or result.stdout or ''),
        vim.log.levels.ERROR
      )
    end)
  end)
end

function M.start_for_buffer(bufnr)
  bufnr = bufnr or 0
  local project, root, remote_root = match_buffer(bufnr)
  if not project then
    return
  end

  start_after_preflight(bufnr, project, root, remote_root)
end

function M.setup(opts)
  opts = opts or {}
  state.capabilities = opts.capabilities

  if opts.projects then
    state.projects = opts.projects
  else
    local ok, projects = pcall(require, 'custom.remote_clangd_projects')
    state.projects = ok and projects or {}
  end

  if #state.projects == 0 then
    return
  end

  local filetypes = {}
  for _, project in ipairs(state.projects) do
    for _, filetype in ipairs(project.filetypes or { 'cuda' }) do
      filetypes[filetype] = true
    end
  end

  local patterns = vim.tbl_keys(filetypes)
  table.sort(patterns)

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('custom-remote-clangd', { clear = true }),
    pattern = patterns,
    callback = function(args)
      M.start_for_buffer(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd('LspDetach', {
    group = vim.api.nvim_create_augroup('custom-remote-clangd-restart', { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client or not client.name:match '^remote_clangd_' then
        return
      end

      local key = client.name .. ':' .. tostring(client.config.root_dir or '') .. ':' .. tostring(args.buf)
      local attempts = (state.restart_attempts[key] or 0) + 1
      state.restart_attempts[key] = attempts

      if attempts > 5 then
        vim.notify('remote clangd stopped repeatedly; not restarting automatically', vim.log.levels.WARN)
        return
      end

      local delay = math.min(30000, 1000 * (2 ^ (attempts - 1)))

      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(args.buf) and vim.api.nvim_buf_is_loaded(args.buf) then
          M.start_for_buffer(args.buf)
        end
      end, delay)
    end,
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('custom-remote-clangd-restart-reset', { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client or not client.name:match '^remote_clangd_' then
        return
      end

      local key = client.name .. ':' .. tostring(client.config.root_dir or '') .. ':' .. tostring(args.buf)
      state.restart_attempts[key] = 0
    end,
  })

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      M.start_for_buffer(bufnr)
    end
  end
end

return M
