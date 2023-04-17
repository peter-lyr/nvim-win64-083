local g = vim.g
local f = vim.fn
local c = vim.cmd
local a = vim.api
local o = vim.opt
local s = vim.keymap.set

if not g.treesitter_loaded then
  g.treesitter_loaded = 1
  g.treesitter_cursormoved = a.nvim_create_autocmd({"CursorMoved"}, {
    callback = function()
      a.nvim_del_autocmd(g.treesitter_cursormoved)
      local sta, _ = pcall(c, 'packadd nvim-treesitter')
      if not sta then
        print("no nvim-treesitter")
        return
      end
      local sta, _ = pcall(c, 'packadd nvim-treesitter-context')
      if not sta then
        print("no nvim-treesitter-context")
        return
      end
      local sta, _ = pcall(c, 'packadd nvim-ts-rainbow')
      if not sta then
        print("no nvim-ts-rainbow")
        return
      end
      local status, treesitter = pcall(require, "nvim-treesitter.configs")
      if not status then
        print('no nvim-treesitter.configs')
        return
      end
      local parser_path = f.expand("$VIMRUNTIME") .. "\\my-neovim-data\\treesitter-parser"
      o.runtimepath:append(parser_path)
      treesitter.setup {
        ensure_installed = {}, -- 'all',
        sync_install = false,
        auto_install = false,
        parser_install_dir = parser_path,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          disable = {
            "markdown",
            "markdown_inline"
          },
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "qi",
            node_incremental = "qi",
            scope_incremental = "qu",
            node_decremental = "qo",
          },
        },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        }
      }
      local status, treesitter_context = pcall(require, "treesitter-context")
      if not status then
        print('no treesitter-context')
        return
      end
      treesitter_context.setup({})
    end,
  })
end
