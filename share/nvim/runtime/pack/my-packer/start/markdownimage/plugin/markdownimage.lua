local g = vim.g
local a = vim.api
local s = vim.keymap.set

local do_markdownimage
local sta
local loaded_do_markdownimage

g.markdownimage_lua = vim.fn['expand']('<sfile>')

local markdownimage_exe = function(params)
  if not loaded_do_markdownimage then
    loaded_do_markdownimage = 1
    sta, do_markdownimage = pcall(require, 'do_markdownimage')
    if not sta then
      print('no do_markdownimage')
      return
    end
  end
  if not do_markdownimage or do_markdownimage == false then
    return
  end
  do_markdownimage.run(params)
end

a.nvim_create_user_command('MarkdownimagE', function(params)
  markdownimage_exe(params['fargs'])
end, { nargs = "*", })

local opt = { silent = true }

s({ 'n', 'v' }, '<leader><f3>', ':<c-u>MarkdownimagE getimage sel_png<cr>', opt)
s({ 'n', 'v' }, '<leader><leader><f3>', ':<c-u>MarkdownimagE getimage sel_jpg<cr>', opt)
s({ 'n', 'v' }, '<leader><leader><leader><f3>', ':<c-u>MarkdownimagE updatesrc cur<cr>', opt)


-- ===========================================================================================


local c = vim.cmd
local b = vim.bo
local f = vim.fn

local gobackbufnr
local lastbufnr
local getimagealways
local dragimagename

local ft = {
  'jpg', 'png',
}

local index_of = function(arr, val)
  if not arr then
    return nil
  end
  for i, v in ipairs(arr) do
    if v == val then
      return i
    end
  end
  return nil
end

a.nvim_create_autocmd({ 'BufReadPre' }, {
  callback = function()
    local cur_fname = a.nvim_buf_get_name(0)
    local extension = string.match(cur_fname, '.+%.(%w+)$')
    if index_of(ft, extension) then
      local last_extension = b[lastbufnr].ft
      if last_extension == 'markdown' then
        if getimagealways then
          gobackbufnr = lastbufnr
        else
          local input = f.input('get image? [y(es)/a(lwayse)/N(o)]: ', 'y')
          if index_of({'y', 'Y' }, input) then
            gobackbufnr = lastbufnr
          elseif index_of({'a', 'A' }, input) then
            gobackbufnr = lastbufnr
            getimagealways = true
          end
        end
        dragimagename = cur_fname
      else
        getimagealways = nil
      end
    end
  end,
})

a.nvim_create_autocmd({ 'BufReadPost' }, {
  callback = function()
    if gobackbufnr then
      local cur_fname = a.nvim_buf_get_name(0)
      c('b' .. gobackbufnr)
      local input = f.input('sel png or jpg? [y(es)/N(o)]: ', 'y')
      local sel_jpg
      if index_of({'y', 'Y' }, input) then
        sel_jpg = 'sel_png'
      else
        sel_jpg = 'sel_jpg'
      end
      markdownimage_exe({'dragimage', sel_jpg, dragimagename})
      c('bw! ' .. cur_fname)
    end
    gobackbufnr = nil
  end,
})

a.nvim_create_autocmd({ 'BufEnter' }, {
  callback = function()
    lastbufnr = f.bufnr()
  end,
})
