local a = vim.api
local b = vim.lsp.buf
local bo = vim.bo
local c = vim.cmd
local d = vim.diagnostic
local f = vim.fn
local s = vim.keymap.set

local sta
local packadd

sta, packadd = pcall(c, 'packadd nvim-lspconfig')
if not sta then
  print(packadd)
  return
end

local mason
sta, mason = pcall(require, "mason")
if not sta then
  print('no mason')
  return
end

local mason_lspconfig
sta, mason_lspconfig = pcall(require, "mason-lspconfig")
if not sta then
  print(mason_lspconfig)
  return
end

local lspconfig
sta, lspconfig = pcall(require, "lspconfig")
if not sta then
  print(lspconfig)
  return
end

mason.setup({
  install_root_dir = f.expand("$VIMRUNTIME") .. "\\my-neovim-data\\mason",
})

mason_lspconfig.setup({
  ensure_installed = {
    "clangd",
    "pyright",
    "lua_ls",
  }
})

local util
sta, util = pcall(require, 'lspconfig.util')
if not sta then
  print(util)
  return
end

local cmp_nvim_lsp
sta, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not sta then
  print(cmp_nvim_lsp)
  return
end

local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig.clangd.setup({
  capabilities = capabilities,
  root_dir = function(fname)
    local root_files = {
      '.clangd',
      '.clang-tidy',
      '.clang-format',
      'compile_commands.json',
      'compile_flags.txt',
      'configure.ac',
      '.git',
      '.svn',
    }
    return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
  end,
})

lspconfig.pyright.setup({
  capabilities = capabilities,
  root_dir = function(fname)
    local root_files = {
      'pyproject.toml',
      'setup.py',
      'setup.cfg',
      'requirements.txt',
      'Pipfile',
      'pyrightconfig.json',
      '.git',
      '.svn',
    }
    return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
  end,
})

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  root_dir = function(fname)
    local root_files = {
      -- '.luarc.json',
      -- '.luarc.jsonc',
      -- '.luacheckrc',
      -- '.stylua.toml',
      -- 'stylua.toml',
      -- 'selene.toml',
      -- 'selene.yml',
      '.git',
      '.svn',
    }
    return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
  end,
})


s('n', '[f', d.open_float)
s('n', ']f', d.setloclist)
s('n', '[d', d.goto_prev)
s('n', ']d', d.goto_next)


s('n', '<leader>fS', function() c('LspStart') end)
s('n', '<leader>fE', function() c('LspRestart') end)
s('n', '<leader>fD', function() c([[call feedkeys(":LspStop ")]]) end)
s('n', '<leader>fF', function() c('LspInfo') end)


a.nvim_create_autocmd('LspAttach', {
  group = a.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = { buffer = ev.buf }
    s({ 'n', 'v' }, 'K', b.definition, opts)
    s({ 'n', 'v' }, '<leader>fo', b.definition, opts)
    s({ 'n', 'v' }, '<leader>fd', b.declaration, opts)
    s({ 'n', 'v' }, '<leader>fh', b.hover, opts)
    s({ 'n', 'v' }, '<leader>fi', b.implementation, opts)
    s({ 'n', 'v' }, '<leader>fs', b.signature_help, opts)
    s({ 'n', 'v' }, '<leader>fe', b.references, opts)
    s({ 'n', 'v' }, '<leader><leader>fd', b.type_definition, opts)
    s({ 'n', 'v' }, '<leader>fn', b.rename, opts)
    s({ 'n', 'v' }, '<leader>ff', function() b.format { async = true } end, opts)
    s({ 'n', 'v' }, '<leader>fc', b.code_action, opts)
  end,
})
