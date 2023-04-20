if 1 then
  return
end

local f = vim.fn
local c = vim.cmd

local ensure_packer = function()
  local install_path = f.expand('$VIMRUNTIME') .. '\\pack\\packer\\start\\packer.nvim'
  if f.empty(f.glob(install_path)) > 0 then
    print('git clone packer.nvim...')
    f.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    print('clone dnoe!')
    c('packadd packer.nvim')
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()

local sta, packer = pcall(require, 'packer')
if not sta then
  print('no packer:', packer)
  return
end

packer.init({
  package_root = f.expand('$VIMRUNTIME') .. '\\pack',
  compile_path = f.expand('$VIMRUNTIME') .. '\\plugin'
})

local plugins = function(use)
  use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', opt = true })
  use({ 'p00f/nvim-ts-rainbow', opt = true })
  use({ 'nvim-treesitter/nvim-treesitter-context', opt = true })

  -- use({ 'nvim-telescope/telescope.nvim', branch = '0.1.x', opt = true }) -- 不再更新官方修改
  use({ 'MattesGroeger/vim-bookmarks', opt = true })
  use({ 'tom-anders/telescope-vim-bookmarks.nvim' })
  use({ 'nvim-telescope/telescope-ui-select.nvim' })
  -- use({ 'ahmedkhalf/project.nvim' }) -- 不再更新官方修改

  use({ 'rafi/awesome-vim-colorschemes' })
  use({ 'EdenEast/nightfox.nvim' })
  use({ 'folke/tokyonight.nvim' })

  use({ 'dstein64/vim-startuptime', opt = true })

  -- use('prichrd/netrw.nvim') -- 不再更新官方修改

  use({ '907th/vim-auto-save', opt = true })

  use({ 'preservim/nerdcommenter', opt = true })

  use({ 'jghauser/mkdir.nvim' })

  use({ 'windwp/nvim-autopairs' })

  use({ 'bitc/vim-bad-whitespace', opt = true })

  use({ 'nvim-tree/nvim-web-devicons' })

  use({ 'tpope/vim-surround', opt = true })

  use({ 'phaazon/hop.nvim', branch = 'v2', opt = true })

  -- use({ 'SirVer/ultisnips', opt = true })                  -- 不再更新官方修改
  -- use({ 'quangnguyen30192/cmp-nvim-ultisnips', opt = true }) -- 不再更新官方修改

  use({ 'hrsh7th/nvim-cmp', opt = true })
  -- use({'hrsh7th/cmp-nvim-lsp', opt = true}) -- 不再更新官方修改
  -- use({'hrsh7th/cmp-buffer', opt = true}) -- 不再更新官方修改
  -- use({'hrsh7th/cmp-path', opt = true}) -- 不再更新官方修改
  -- use({'hrsh7th/cmp-cmdline', opt = true}) -- 不再更新官方修改

  use({ 'neovim/nvim-lspconfig', opt = true })
  use({ 'williamboman/mason.nvim' })
  use({ 'williamboman/mason-lspconfig.nvim' })

  use({ 'lewis6991/gitsigns.nvim' })
  use({ 'tpope/vim-fugitive', opt = true })
  use({ 'sindrets/diffview.nvim', opt = true })

  use({ 'folke/which-key.nvim' })

  use({ 'dbakker/vim-projectroot' })

  use({ 'lukas-reineke/indent-blankline.nvim', opt = true })

  use({ 'kevinhwang91/nvim-bqf', opt = true })

  use({ 'azabiong/vim-highlighter' })

  use({ 'google/vim-searchindex', opt = true })

  use({ 'skywind3000/asyncrun.vim', opt = true })

  use({ 'dstein64/nvim-scrollview', opt = true })

  use({ 'stevearc/aerial.nvim', opt = true })
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
