local f = vim.fn
local a = vim.api
local c = vim.cmd

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

local newcnt = 0

M.getnew = function()
  local fname
  local fpath
  local cwd
  local branch
  local new = {}
  newcnt = 0
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
    if fpath:exists() ~= true or fpath:is_dir() then
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
    newcnt = newcnt + 1
    if not vim.tbl_contains(vim.tbl_keys(new), cwd) then
      local f1 = { fname }
      local b1 = {}
      b1[branch] = f1
      new[cwd] = b1
    else
      if not vim.tbl_contains(vim.tbl_keys(new[cwd]), branch) then
        new[cwd][branch] = { fname }
      else
        table.insert(new[cwd][branch], fname)
      end
    end
    ::continue::
  end
  return new
end

M.savesession = function()
  local old = loadstring('return ' .. session:read())()
  local new = M.getnew()
  for cwd, v1 in pairs(old) do
    if not vim.tbl_contains(vim.tbl_keys(new), cwd) then
      new[cwd] = v1
    else
      for branch, fnames in pairs(v1) do
        if not vim.tbl_contains(vim.tbl_keys(new[cwd]), branch) then
          new[cwd][branch] = fnames
        -- else
        --   for _, fname in ipairs(fnames) do
        --     if not vim.tbl_contains(new[cwd][branch], fname) then
        --       table.insert(new[cwd][branch], fname)
        --       print("fname:", vim.inspect(fname))
        --     end
        --   end
        end
      end
    end
  end
  local newcontent = tostring(vim.inspect(new))
  session:write(newcontent, 'w')
  print('save ' .. #vim.tbl_keys(new) .. ' cwd, ' .. newcnt .. ' opened files')
end

local bwande = function(cwd, fnames)
  cwd = f['tolower'](cwd)
  for _, bufnr in ipairs(a.nvim_list_bufs()) do
    local fname = string.gsub(a.nvim_buf_get_name(bufnr), '\\', '/')
    local curcwd = f['projectroot#get'](fname)
    curcwd = f['tolower'](curcwd)
    if curcwd == cwd then
      if not vim.tbl_contains(fnames, fname) then
        c('bw! ' .. fname)
      end
    end
  end
  for _, fname in ipairs(fnames) do
    c('e ' .. fname)
  end
  f['tabline#restorehiddenprojects']()
end

M.loadsession = function()
  local cwds = loadstring('return ' .. session:read())()
  vim.ui.select(vim.tbl_keys(cwds), { prompt = 'cwd' }, function(cwd, _)
    local branches = cwds[cwd]
    if #vim.tbl_keys(branches) == 1 then
      for _, fnames in pairs(branches) do
        bwande(cwd, fnames)
      end
    else
      vim.ui.select(vim.tbl_keys(branches), { prompt = 'branch' }, function(branch, _)
        local fnames = branches[branch]
        bwande(cwd, fnames)
      end)
    end
  end)
end

M.run = function(params)
  if not params or #params == 0 then
    return
  end

  if #params == 1 then
    local param = params[1]
    if param == 'save' then
      M.savesession()
    elseif param == 'load' then
      M.loadsession()
    end
  end
end

return M
