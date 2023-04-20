local o = vim.opt
local a = vim.api
local c = vim.cmd
local s = vim.keymap.set

local do_quickfix = nil
local loaded_do_quickfix = nil
local quickfix_cursormoved = nil

local sta = nil

local cnt = 0

local function init()
  if not loaded_do_quickfix then
    loaded_do_quickfix = 1
    sta, do_quickfix = pcall(require, 'do_quickfix')
    if not sta then
      print('no do_quickfix')
      return
    end
  end
  if cnt < 8 then
    cnt = cnt + 1
    c([[
      hi BqfPreviewBorder guifg=#50a14f ctermfg=71
      hi link BqfPreviewRange Search
    ]])
  end
end

local quickfix_exe = function()
  init()
  if not do_quickfix then
    return
  end
  do_quickfix.run()
end

quickfix_cursormoved = a.nvim_create_autocmd({ "CursorMoved" }, {
  callback = function()
    if o.ft:get() == 'qf' then
      a.nvim_del_autocmd(quickfix_cursormoved)
    end
    init()
  end,
})

a.nvim_create_user_command('QuickfiX', function()
  quickfix_exe()
end, { nargs = "*", })


local opt = { silent = true }

s({ 'n', 'v' }, '<leader>m', ':QuickfiX toggle<cr>', opt)
