local g = vim.g
local a = vim.api
local o = vim.opt
local s = vim.keymap.set

local sta = nil
local do_markdown2pdfhtmldocx = nil

g.markdown2pdfhtmldocx_lua = vim.fn['expand']('<sfile>')

local markdown2pdfhtmldocx_exe = function(cmd)
  if not g.loaded_do_markdown2pdfhtmldocx then
    g.loaded_do_markdown2pdfhtmldocx = 1
    sta, do_markdown2pdfhtmldocx = pcall(require, 'do_markdown2pdfhtmldocx')
    if not sta then
      print('no do_markdown2pdfhtmldocx')
      return
    end
  end
  if not do_markdown2pdfhtmldocx then
    return
  end
  if o.ft:get() == 'markdown' then
    do_markdown2pdfhtmldocx.do_markdown2pdfhtmldocx(cmd)
  end
end

a.nvim_create_user_command('Markdown2PdfHtmlDocx', function(params)
  markdown2pdfhtmldocx_exe(unpack(params['fargs']))
end, { nargs = '*', })

s({ 'n', 'v' }, '\\1', ':Markdown2PdfHtmlDocx create<cr>', { silent = true })
s({ 'n', 'v' }, '\\2', ':Markdown2PdfHtmlDocx delete<cr>', { silent = true })
