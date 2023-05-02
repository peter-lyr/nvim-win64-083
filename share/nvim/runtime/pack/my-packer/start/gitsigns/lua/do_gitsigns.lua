local c = vim.cmd

local sta, gitsigns = pcall(require, "gitsigns")
if not sta then
  print(gitsigns)
  return {}
end

gitsigns.setup({
  -- current_line_blame = true,
  -- current_line_blame_opts = {
  --   delay = 120,
  -- },
})

local M = {}

M.run = function(cmd, refresh)
  if not cmd or #cmd == 0 then
    return
  end
  local d1
  sta, d1 = pcall(c, 'Gitsigns ' .. cmd)
  if not sta then
    print(d1)
    return
  end
  if refresh == "1" then
    c[[call feedkeys(":e!\<cr>")]]
  end
end

return M
