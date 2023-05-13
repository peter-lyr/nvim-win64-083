local f = vim.fn
local a = vim.api

local M = {}

local sta, Path = pcall(require, "plenary.path")
if not sta then
  print(Path)
  return
end

local datapath = Path:new(f['expand']("$VIMRUNTIME") .. "\\my-neovim-data")

if not datapath:exists() then
  f['mkdir'](datapath.filename)
end

local sessionpath = datapath:joinpath("Session")
if not sessionpath:exists() then
  f['mkdir'](sessionpath.filename)
end

local session = sessionpath:joinpath("session_cwd_branch_fname.txt")
if not session:exists() then
  session:touch()
end

local D = {}

M.savesession = function()
  -- for _, v in ipairs(session:readlines()) do
  --   print("v:", v)
  -- end
  local fname
  local fpath
  local cwd
  local branch
  D = {}
  for _, bufnr in ipairs(a.nvim_list_bufs()) do
    if f['buflisted'](bufnr) == 0 or a.nvim_buf_is_loaded(bufnr) == false then
      goto continue
    end
    if f['getbufvar'](bufnr, '&readonly') == 1 then
      goto continue
    end
    fname = string.gsub(a.nvim_buf_get_name(bufnr), '\\', '/')
    fname = f['tolower'](fname)
    if #fname == 0 then
      goto continue
    end
    fpath = Path:new(fname)
    if fpath:exists() ~= true then
      goto continue
    end
    f['gitbranch#detect'](fpath:parent().filename)
    cwd = f['projectroot#get'](fname)
    if #cwd == 0 then
      cwd = '-'
      branch = '-'
    else
      branch = f['gitbranch#name']()
    end
    if not vim.tbl_contains(vim.tbl_keys(D), cwd) then
      local f1 = { fname }
      local b1 = {}
      b1[branch] = f1
      D[cwd] = b1
    else
      if not vim.tbl_contains(vim.tbl_keys(D[cwd]), branch) then
        D[cwd][branch] = { fname }
      else
        table.insert(D[cwd][branch], fname)
      end
    end
    ::continue::
  end
  print("D:", vim.inspect(D))
end

M.run = function(params)
  if not params or #params == 0 then
    return
  end

  if #params == 1 then
    local param = params[1]
    if param == 'all' then
      M.savesession()
    end
  end
end

return M
