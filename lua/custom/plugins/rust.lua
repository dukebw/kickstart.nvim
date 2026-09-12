return {
  {
    'mrcjkb/rustaceanvim',
    version = '^9',
    lazy = false,
    init = function()
      local rust_lsp = function(command)
        return function()
          vim.cmd.RustLsp(command)
        end
      end

      vim.g.rustaceanvim = {
        tools = {
          test_executor = 'background',
          code_actions = {
            ui_select_fallback = true,
          },
        },
        server = {
          on_attach = function(_, bufnr)
            local map = function(mode, keys, command, desc)
              vim.keymap.set(mode, keys, command, { buffer = bufnr, silent = true, desc = desc })
            end

            map('n', 'K', rust_lsp { 'hover', 'actions' }, 'Rust: Hover actions')
            map({ 'n', 'x' }, '<leader>Ra', rust_lsp 'codeAction', 'Rust: Code action')
            map('n', '<leader>Rr', rust_lsp 'runnables', 'Rust: Runnables')
            map('n', '<leader>Rt', rust_lsp 'testables', 'Rust: Testables')
            map('n', '<leader>Rd', rust_lsp 'debuggables', 'Rust: Debuggables')
            map('n', '<leader>Re', rust_lsp 'explainError', 'Rust: Explain error')
            map('n', '<leader>RE', rust_lsp 'renderDiagnostic', 'Rust: Render diagnostic')
            map('n', '<leader>Rm', rust_lsp 'expandMacro', 'Rust: Expand macro')
            map('n', '<leader>Rc', rust_lsp 'openCargo', 'Rust: Open Cargo.toml')
            map('n', '<leader>RD', rust_lsp 'openDocs', 'Rust: Open docs.rs')

            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end,
        },
      }
    end,
  },
  {
    'saecki/crates.nvim',
    tag = 'stable',
    event = { 'BufRead Cargo.toml', 'BufNewFile Cargo.toml' },
    opts = {
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
    config = function(_, opts)
      local crates = require 'crates'
      opts.on_attach = function(bufnr)
        local map = function(mode, keys, command, desc)
          vim.keymap.set(mode, keys, command, { buffer = bufnr, silent = true, desc = desc })
        end

        map('n', '<leader>Cv', crates.show_versions_popup, 'Crates: Show versions')
        map('n', '<leader>Cf', crates.show_features_popup, 'Crates: Show features')
        map('n', '<leader>Cd', crates.show_dependencies_popup, 'Crates: Show dependencies')
        map({ 'n', 'x' }, '<leader>Cu', function()
          if vim.fn.mode():match '[vV\22]' then
            crates.update_crates()
          else
            crates.update_crate()
          end
        end, 'Crates: Update compatible')
        map({ 'n', 'x' }, '<leader>CU', function()
          if vim.fn.mode():match '[vV\22]' then
            crates.upgrade_crates()
          else
            crates.upgrade_crate()
          end
        end, 'Crates: Upgrade latest')
      end
      crates.setup(opts)
    end,
  },
}
