local g = vim.g
local a = vim.api
local o = vim.opt
local f = vim.fn

local sta = nil
local do_markdown2pdfhtmldocx = nil
local loaded_do_markdown2pdfhtmldocx = nil
local markdown2pdfhtmldocx_cursormoved = nil

g.markdown2pdfhtmldocx_lua = f['expand']('<sfile>')

local markdown2pdfhtmldocx = function(cmd)
  if not loaded_do_markdown2pdfhtmldocx then
    loaded_do_markdown2pdfhtmldocx = 1
    a.nvim_del_autocmd(markdown2pdfhtmldocx_cursormoved)
    sta, do_markdown2pdfhtmldocx = pcall(require, 'do_markdown2pdfhtmldocx')
    if not sta then
      print('no do_markdown2pdfhtmldocx')
      return
    end
  end
  if not do_markdown2pdfhtmldocx or not cmd or #cmd == 0 then
    return
  end
  if o.ft:get() == 'markdown' then
    do_markdown2pdfhtmldocx.do_markdown2pdfhtmldocx(cmd)
  end
end

markdown2pdfhtmldocx_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    markdown2pdfhtmldocx()
  end,
})

a.nvim_create_user_command('Markdown2PdfHtmlDocx', function(params)
  markdown2pdfhtmldocx(unpack(params['fargs']))
end, { nargs = '*', })


local s = vim.keymap.set
local opt = { silent = true }
s({ 'n', 'v' }, '\\1', ':Markdown2PdfHtmlDocx create<cr>', opt)
s({ 'n', 'v' }, '\\2', ':Markdown2PdfHtmlDocx delete<cr>', opt)
