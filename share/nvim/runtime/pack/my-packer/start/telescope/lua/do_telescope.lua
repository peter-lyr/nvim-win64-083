local c = vim.cmd
local f = vim.fn

local sta

local add_pack_help = function(plugnames)
  local _sta, _path
  _sta, _path = pcall(require, "plenary.path")
  if not _sta then
    print(_path)
    return nil
  end
  local doc_path
  local packadd
  _path = _path:new(f.expand("$VIMRUNTIME"))
  local opt_path = _path:joinpath('pack', 'packer', 'opt')
  for _, plugname in ipairs(plugnames) do
    doc_path = opt_path:joinpath(plugname, 'doc')
    _sta, packadd = pcall(c, 'packadd ' .. plugname)
    if not _sta then
      print(packadd)
      return nil
    end
    if doc_path:is_dir() then
      c('helptags ' .. doc_path.filename)
    end
  end
  return true
end

if not add_pack_help({ 'telescope.nvim' }) then
  return nil
end


local telescope
sta, telescope = pcall(require, 'telescope')
if not sta then
  print(telescope)
  return
end

local actions
sta, actions = pcall(require, 'telescope.actions')
if not sta then
  print(actions)
  return
end

local actions_layout
sta, actions_layout = pcall(require, 'telescope.actions.layout')
if not sta then
  print(actions_layout)
  return
end

c[[
autocmd User TelescopePreviewerLoaded setlocal number | setlocal wrap
]]

telescope.setup({
  defaults = {
    layout_strategy = 'horizontal',
    layout_config = {
      height = 0.99,
      width = 0.99,
    },
    preview = {
      hide_on_startup = true,
    },
    mappings = {
      i = {
        ['<a-m>'] = actions.close,
        ['<a-j>'] = actions.move_selection_next,
        ['<a-k>'] = actions.move_selection_previous,
        ['<a-;>'] = actions.send_to_qflist + actions.open_qflist,
        ['<c-j>'] = actions.select_horizontal,
        ['<c-l>'] = actions.select_vertical,
        ['<c-k>'] = actions.select_tab,
        ['<c-o>'] = actions.select_default,
				['<a-n>'] = actions_layout.toggle_preview,
      },
      n = {
        ['ql'] = actions.close,
        ['<a-m>'] = actions.close,
        ['<a-j>'] = actions.move_selection_next,
        ['<a-k>'] = actions.move_selection_previous,
        ['<a-;>'] = actions.send_to_qflist + actions.open_qflist,
        ['<c-j>'] = actions.select_horizontal,
        ['<c-l>'] = actions.select_vertical,
        ['<c-k>'] = actions.select_tab,
        ['<c-o>'] = actions.select_default,
				['w'] = actions_layout.toggle_preview,
      }
    },
    file_ignore_patterns = {
      '%.svn',
      '%.vs',
      '%.git',
      '%.cache',
      'obj',
      'build',
      'my%-neovim%-data',
      '%.js',
      '%.asc',
      '%.hex',
      'CMakeLists.txt',
      -- 'map.txt',
      -- '%.lst',
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--fixed-strings',
    },
    wrap_results = true,
  },
})


if add_pack_help({ 'aerial.nvim' }) then
  local aerial
  sta, aerial = pcall(telescope.load_extension, "aerial")
  if not sta then
    print(aerial)
  end
end


local projects
sta, projects = pcall(telescope.load_extension, "projects")
if not sta then
  print(projects)
end


local vim_bookmarks
sta, vim_bookmarks = pcall(telescope.load_extension, "vim_bookmarks")
if not sta then
  print(vim_bookmarks)
end


local ui_select
sta, ui_select = pcall(telescope.load_extension, "ui-select")
if not sta then
  print(ui_select)
end


local M = {}

local do_projects
local do_bookmarks

M.run = function(params)
  if not params or #params == 0 then
    return
  end
  local cmd = table.concat(params, ' ')
  if cmd == 'projects' then
    if not do_projects then
      sta, do_projects = pcall(require, 'do_projects')
      if not sta then
        print(do_projects)
        return
      end
    end
  elseif string.find(cmd, '^vim_bookmarks') then
    if not do_bookmarks then
      sta, do_bookmarks = pcall(require, 'do_bookmarks')
      if not sta then
        print(do_bookmarks)
        return
      end
    end
  end
  c(string.format([[
  try
    Telescope %s
  catch
    echomsg "no %s"
  endtry]], cmd, cmd))
end

return M
