local M = {}

local g = vim.g
local c = vim.cmd
local o = vim.opt

local Path = require("plenary.path")

local path = Path:new(g.markdownpreview_lua)
path = path:parent():parent()
g.mkdp_markdown_css = path:joinpath('autoload', 'mkdp_markdown.css')['filename']

function M.do_markdownpreview(cmd)
  if o.ft:get() == 'markdown' then
    c(cmd)
  end
end

return M
