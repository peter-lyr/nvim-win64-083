local c = vim.cmd
local a = vim.api
local g = vim.g

local M = {}

local cnt = 0
local sta

M.run = function()
  cnt = cnt + 1
  if g.blankline_cursormoved then
    if cnt > 1 then
      a.nvim_del_autocmd(g.blankline_cursormoved)
      g.blankline_cursormoved = nil
    elseif cnt == 1 then
      sta, _ = pcall(c, 'packadd indent-blankline.nvim')
      if not sta then
        print("no indent_blankline")
        return
      end
      local indent_blankline
      sta, indent_blankline = pcall(require, 'indent_blankline')
      if not sta then
        print(indent_blankline)
        return
      end
      indent_blankline.setup {
        show_current_context = true,
        show_current_context_start = true,
        space_char_blankline = " ",
        char_highlight_list = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
          "IndentBlanklineIndent3",
          "IndentBlanklineIndent4",
          "IndentBlanklineIndent5",
          "IndentBlanklineIndent6",
        },
      }
    end
  end
  c [[
    highlight IndentBlanklineIndent1 guifg=#E06C75
    highlight IndentBlanklineIndent2 guifg=#E5C07B
    highlight IndentBlanklineIndent3 guifg=#98C379
    highlight IndentBlanklineIndent4 guifg=#56B6C2
    highlight IndentBlanklineIndent5 guifg=#61AFEF
    highlight IndentBlanklineIndent6 guifg=#C678DD
  ]]
end

return M
