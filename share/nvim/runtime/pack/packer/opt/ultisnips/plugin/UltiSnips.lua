local g = vim.g
local a = vim.api
local c = vim.cmd

if not g.ultisnips_loaded2 then
  g.ultisnips_loaded2 = 1
  g.ultisnips_cursormoved2 = a.nvim_create_autocmd({"CursorMoved"}, {
    callback = function()
      a.nvim_del_autocmd(g.ultisnips_cursormoved2)
      local sta, _ = pcall(require, "UltiSnips_after")
      if not sta then
        print("no UltiSnips_after")
      end
    end,
  })
end
