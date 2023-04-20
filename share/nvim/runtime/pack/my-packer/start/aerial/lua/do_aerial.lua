local c = vim.cmd

local sta, packadd = pcall(c, 'packadd aerial.nvim')
if not sta then
  print(packadd)
  return
end

local aerial
sta, aerial = pcall(require, 'aerial')
if not sta then
  print(aerial)
  return
end

aerial.setup({
  keymaps = {
    ['?'] = 'actions.show_help',
    ['o'] = 'actions.jump',
    ['a'] = 'actions.jump',
    ['<2-LeftMouse>'] = 'actions.jump',
    ['<C-v>'] = 'actions.jump_vsplit',
    ['<C-s>'] = 'actions.jump_split',
    ['<tab>'] = 'actions.scroll',
    ['<C-j>'] = 'actions.down_and_scroll',
    ['<C-k>'] = 'actions.up_and_scroll',
    ['{'] = 'actions.prev',
    ['}'] = 'actions.next',
    ['[['] = 'actions.prev_up',
    [']]'] = 'actions.next_up',
    ['q'] = 'actions.close',
    -- ['a'] = 'actions.tree_toggle',
    ['O'] = 'actions.tree_toggle_recursive',
    ['zA'] = 'actions.tree_toggle_recursive',
    ['l'] = 'actions.tree_open',
    ['zo'] = 'actions.tree_open',
    ['L'] = 'actions.tree_open_recursive',
    ['zO'] = 'actions.tree_open_recursive',
    ['h'] = 'actions.tree_close',
    ['zc'] = 'actions.tree_close',
    ['H'] = 'actions.tree_close_recursive',
    ['zC'] = 'actions.tree_close_recursive',
    ['zr'] = 'actions.tree_increase_fold_level',
    ['zR'] = 'actions.tree_open_all',
    ['zm'] = 'actions.tree_decrease_fold_level',
    ['zM'] = 'actions.tree_close_all',
    ['zx'] = 'actions.tree_sync_folds',
    ['zX'] = 'actions.tree_sync_folds',
  },
  post_jump_cmd = [[call feedkeys('zt3\<c-y>')]],
  close_automatic_events = { 'unfocus', 'switch_buffer', 'unsupported' },
  close_on_select = true,
  float = {
    relative = 'win',
  }
})
