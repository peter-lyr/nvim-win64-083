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

s({ 'n', 'v' }, '<f3>p', ':<c-u>MarkdownimagE getimage sel_png<cr>', opt)
s({ 'n', 'v' }, '<f3>j', ':<c-u>MarkdownimagE getimage sel_jpg<cr>', opt)
s({ 'n', 'v' }, '<f3>u', ':<c-u>MarkdownimagE updatesrc cur<cr>', opt)


-- ===========================================================================================


local c = vim.cmd
local b = vim.bo
local f = vim.fn

local gobackbufnr
local lastbufnr
local getimagealways
local dragimagename
local cancelopen

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
        local lastbufname = a.nvim_buf_get_name(lastbufnr)
        local projectroot_path = Path:new(f['projectroot#get'](lastbufname))
        if projectroot_path.filename == '' then
          gobackbufnr = lastbufnr
          cancelopen = true
          print('not projectroot:', lastbufname)
          print('cancelopen')
          return
        end
        if getimagealways then
          gobackbufnr = lastbufnr
        else
          local input = f.input('get image? [y(es)/a(lwayse)/o(pen)]: ', 'y')
          if index_of({ 'y', 'Y' }, input) then
            gobackbufnr = lastbufnr
          elseif index_of({ 'a', 'A' }, input) then
            gobackbufnr = lastbufnr
            getimagealways = true
          elseif input == '' then
            gobackbufnr = lastbufnr
            cancelopen = true
          end
        end
        dragimagename = cur_fname
      else
        getimagealways = nil
      end
    end
  end,
})

local sel_jpg = 'sel_png'

a.nvim_create_autocmd({ 'BufReadPost' }, {
  callback = function()
    if gobackbufnr then
      local curbufnr = f.bufnr()
      c('b' .. gobackbufnr)
      gobackbufnr = nil
      if cancelopen then
        cancelopen = nil
        c('bw! ' .. curbufnr)
        return
      end
      if sel_jpg and index_of({ 'sel_png', 'sel_jpg' }, sel_jpg) then
        markdownimage_exe({ 'dragimage', sel_jpg, dragimagename })
        c 'w!'
        c('bw! ' .. curbufnr)
      else
        vim.ui.select({ 'sel_png', 'sel_jpg' }, { prompt = 'sel png or jpg' }, function(choice, _)
          local sel_jpg_tmp = choice
          markdownimage_exe({ 'dragimage', sel_jpg_tmp, dragimagename })
          c 'w!'
          c('bw! ' .. curbufnr)
        end)
      end

    end
  end,
})

a.nvim_create_autocmd({ 'BufEnter' }, {
  callback = function()
    lastbufnr = f.bufnr()
  end,
})
