local f = vim.fn

local sta, project_nvim = pcall(require, "project_nvim")
if not sta then
  print('no project_nvim')
  return
end

local datapath = f['expand']("$VIMRUNTIME") .. "\\my-neovim-data"
if f['filereadable'](datapath) == 0 then
  os.execute('cd ' .. f['expand']("$VIMRUNTIME") .. ' && md my-neovim-data')
end

project_nvim.setup({
  manual_mode = false,
  datapath = datapath,
  detection_methods = { "pattern", "lsp" },
  patterns = {
    ".cache",
    "build",
    "compile_commands.json",
    "CMakeLists.txt",
    ".git",
    -- ".svn",
  }
})

local g = vim.g

g.rootmarkers = {
  ".cache",
  "build",
  "compile_commands.json",
  "CMakeLists.txt",
  ".git",
  -- ".svn",
  -- '.projectroot',
  -- '.git',
  -- '.hg',
  -- '.svn',
  -- '.bzr',
  -- '_darcs',
  -- 'build.xml'
}
