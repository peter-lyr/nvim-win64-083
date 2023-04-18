local M = {}

local config = require('netrw.config')
local parse = require('netrw.parse')

---@param key string
M.dispatch = function(key)
  local bufnr = vim.api.nvim_get_current_buf()
  local winid = vim.api.nvim_get_current_win()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(winid))
  local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)
  local payload = parse.get_node(line[1])
  local r = string.gsub(key, '%>', ')')
  local r = string.gsub(r, '%<', '(')
  config.options.mappings[r](payload)
end

---@param bufnr number
M.bind = function(bufnr)
  local opts = { noremap = true, silent = true, nowait = true }
  for k, _ in pairs(config.options.mappings) do
    local r = string.gsub(k, '%(', '<')
    local r = string.gsub(r, '%)', '>')
    local mouse = ''
    if r == "<leftmouse>" then
      mouse = '<leftmouse>'
    elseif r == "<rightmouse>" then
      mouse = '<rightmouse>'
    elseif r == "<2-leftmouse>" then
      mouse = '<2-leftmouse>'
    end
    local _, has_dquote = string.find(k, '(")')
    if has_dquote then
      local _, has_quote = string.find(k, "(')")
      if not has_quote then
        vim.api.nvim_buf_set_keymap(bufnr, 'n', r, mouse .. ':lua require"netrw.actions".dispatch(\'' .. k .. '\')<cr>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'v', r, mouse .. ':lua require"netrw.actions".dispatch(\'' .. k .. '\')<cr>', opts)
      else
        print('cannot \' " together', k)
      end
    else
        vim.api.nvim_buf_set_keymap(bufnr, 'n', r, mouse .. ':lua require"netrw.actions".dispatch("' .. k .. '")<cr>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'v', r, mouse .. ':lua require"netrw.actions".dispatch("' .. k .. '")<cr>', opts)
    end
  end
end

return M
