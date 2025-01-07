-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI.
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui.
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you.
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here.
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<leader>ec',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<leader>es',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<leader>en',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<leader>eS',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>eb',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>eB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<leader>eg',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
    {
      '<leader>ep',
      function()
        require('dap').set_breakpoint(nil, nil, vim.fn.input 'Log point message: ')
      end,
      desc = 'Debug: Set Logpoint',
    },
    {
      '<leader>eu',
      function()
        require('dap').up()
      end,
      desc = 'Debug: Stack Up',
    },
    {
      '<leader>ed',
      function()
        require('dap').down()
      end,
      desc = 'Debug: Stack Down',
    },
    {
      '<leader>er',
      function()
        require('dap').repl.open()
      end,
      desc = 'Debug: Open REPL',
    },
    {
      '<leader>el',
      function()
        require('dap').run_last()
      end,
      desc = 'Debug: Run Last',
    },
    {
      '<leader>et',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: Terminate',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open

    -- Install golang specific config.
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- Install Python specific config.
    local dap_python = require 'dap-python'
    dap_python.setup()
    dap_python.test_runner = 'pytest'

    -- Configure nvim-dap for C++.
    dap.adapters.lldb = {
      type = 'executable',
      command = '/usr/bin/lldb-dap', -- must be absolute path
      name = 'lldb',
    }

    local function read_config()
      local config_path = vim.fn.getcwd() .. '/.nvim-dap.json'
      print('config_path: ' .. config_path)
      local ok, content = pcall(vim.fn.readfile, config_path)
      if not ok then
        vim.notify('Config file not found: ' .. config_path, vim.log.levels.WARN)
        return nil
      end

      local ok2, config = pcall(vim.json.decode, table.concat(content, '\n'))
      if not ok2 then
        vim.notify('Error parsing JSON config', vim.log.levels.ERROR)
        return nil
      end
      return config
    end

    local function get_config_or_prompt(key, prompt, default)
      local config = read_config()
      print 'config: '
      print(config)
      if config and config[key] then
        return config[key]
      end

      return function()
        return vim.ui.input({
          prompt = prompt,
          default = default or '',
        }, function(input)
          return input
        end)
      end
    end

    dap.configurations.cpp = {
      {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = get_config_or_prompt('program', 'Path to executable: ', vim.fn.getcwd() .. '/'),
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = function()
          local config = read_config()
          if config and config.cpp_args then
            return config.cpp_args
          end

          return vim.ui.input({
            prompt = 'Args: ',
          }, function(input)
            return input and vim.split(input, ' ') or {}
          end)
        end,
        env = function()
          local config = read_config()
          return vim.tbl_deep_extend('force', {}, config and config.env or {})
        end,
        initCommands = function()
          local config = read_config()
          if not config or not config.env then
            return {}
          end

          return vim.tbl_map(function(k)
            return string.format('settings set target.env-vars %s="%s"', k, config.env[k])
          end, vim.tbl_keys(config.env))
        end,
      },
      {
        name = 'Attach to Process',
        type = 'lldb',
        request = 'attach',
        pid = require('dap.utils').pick_process,
        cwd = '${workspaceFolder}',
      },
    }
  end,
}
