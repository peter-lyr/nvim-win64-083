if vim.fn['has']("patch-8.1.0360") == 1 then
  vim.cmd('set diffopt+=internal,algorithm:patience')
end
