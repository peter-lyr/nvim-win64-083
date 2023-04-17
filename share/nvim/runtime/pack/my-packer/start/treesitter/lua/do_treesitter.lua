local c = vim.cmd
local f = vim.fn
local g = vim.g

local M = {}

M.run = function()
  if not g.treesitter_do_loaded then
    g.treesitter_do_loaded = 1
    local sta, packadd = pcall(c, 'packadd nvim-treesitter')
    if not sta then
      print("no packadd nvim-treesitter:", packadd)
      return
    end
    local sta, treesitter = pcall(require, "nvim-treesitter.configs")
    if not sta then
      print('no nvim-treesitter.configs:', treesitter)
      return
    end
    local sta, packadd = pcall(c, 'packadd nvim-treesitter-context')
    if not sta then
      print("no packadd nvim-treesitter-context:", packadd)
    end
    local sta, packadd = pcall(c, 'packadd nvim-ts-rainbow')
    if not sta then
      print("no packadd nvim-ts-rainbow:", packadd)
    end
    local parser_path = f.expand("$VIMRUNTIME") .. "\\my-neovim-data\\treesitter-parser"
    o.runtimepath:append(parser_path)
    treesitter.setup({
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
    })
    local sta, treesitter_context = pcall(require, "treesitter-context")
    if not sta then
      print('no treesitter-context')
    end
    treesitter_context.setup({})
  end
end

return M
