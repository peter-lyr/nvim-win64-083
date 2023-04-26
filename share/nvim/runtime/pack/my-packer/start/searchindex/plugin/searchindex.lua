local a = vim.api

local searchindex_cursormoved

searchindex_cursormoved = a.nvim_create_autocmd({ "CursorMoved" }, {
  callback = function()
    a.nvim_del_autocmd(searchindex_cursormoved)
    local sta, do_searchindex = pcall(require, 'do_searchindex')
    if not sta then
      print(do_searchindex)
      return
    end
  end,
})
