local a = vim.api

Test_autocmd = a.nvim_create_autocmd({ 'BufReadPre' }, {
  callback = function()
    print(a.nvim_buf_get_name(0))
  end,
})
