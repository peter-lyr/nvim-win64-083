-- if 1 then
--   return
-- end

local fn = vim.fn

local ensure_packer = function()
  local install_path = fn.expand('$VIMRUNTIME') .. '\\pack\\packer\\start\\packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    print('git clone packer.nvim...')
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    print('clone dnoe!')
    vim.cmd('packadd packer.nvim')
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()

local sta, packer = pcall(require, 'packer')
if not sta then
  print("no packer:", packer)
  return
end

packer.init({
  package_root = fn.expand('$VIMRUNTIME') .. '\\pack',
  compile_path = fn.expand('$VIMRUNTIME') .. '\\plugin'
})

local plugins = function(use)
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", opt = true })
end

return packer.startup(function(use)
  use('wbthomason/packer.nvim')
  -- use('nvim-lua/plenary.nvim') -- 不再更新官方修改

  plugins(use)

  if packer_bootstrap then
    print('packer sync...')
    require('packer').sync()
    print('sync done!')
  end
end)
