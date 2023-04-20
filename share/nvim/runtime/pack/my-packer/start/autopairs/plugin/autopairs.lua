local a = vim.api

local autopairs_cursormoved = nil

local autopairs = function()
    a.nvim_del_autocmd(autopairs_cursormoved)
    local sta, do_autopairs = pcall(require, 'do_autopairs')
    if not sta then
      print(do_autopairs)
    end
end

autopairs_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    autopairs()
  end,
})
