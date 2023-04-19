let s:bufferjump_miximize = 1

fu! bufferjump#up(cnt)
  exe string(a:cnt) . 'wincmd k'
  if s:bufferjump_miximize && &winfixheight == 0
    wincmd _
  endif
endfu

fu! bufferjump#down(cnt)
  exe string(a:cnt) . 'wincmd j'
  if s:bufferjump_miximize && &winfixwidth == 0
    wincmd _
  endif
  if &winfixwidth == 1
    call nvim_win_set_width(0, 36)
  endif
endfu

fu! bufferjump#left(cnt)
  exe string(a:cnt) . 'wincmd h'
endfu

fu! bufferjump#right(cnt)
  exe string(a:cnt) . 'wincmd l'
endfu

fu! bufferjump#miximize(enable)
  if a:enable
    let s:bufferjump_miximize = 1
    wincmd _
  else
    let s:bufferjump_miximize = 0
    wincmd =
  endif
endfu

fu! bufferjump#maxheight()
  wincmd _
endfu

fu! bufferjump#samewidthheight()
  wincmd =
  if &winfixheight == 1
    set nowinfixheight
    wincmd =
    set winfixheight
  endif
endfu

fu! bufferjump#samewidthheightfix()
  let cur_winid = win_getid(winnr())
  for i in range(1, winnr('$'))
    let bufnr = winbufnr(i)
    call win_gotoid(win_getid(bufwinnr(bufnr)))
    if &winfixheight == 1
      call nvim_win_set_height(0, 12)
    endif
    if &winfixwidth == 1
      call nvim_win_set_width(0, 36)
    endif
  endfor
  wincmd =
  call win_gotoid(cur_winid)
endfu

fu! bufferjump#maxwidth()
  wincmd |
endfu

fu! bufferjump#winfixheight()
  echomsg 'set winfixheight'
  set winfixheight
endfu

fu! bufferjump#nowinfixheight()
  echomsg 'set nowinfixheight'
  set nowinfixheight
endfu

fu! bufferjump#winfixwidth()
  echomsg 'set winfixwidth'
  set winfixwidth
endfu

fu! bufferjump#nowinfixwidth()
  echomsg 'set nowinfixwidth'
  set nowinfixwidth
endfu

lua << EOF
local s = vim.keymap.set
local o = { silent = true }
s({ 'n', 'v' }, '2<leader>w', ':call bufferjump#up(2)<cr>', o)
s({ 'n', 'v' }, '2<leader>s', ':call bufferjump#down(2)<cr>', o)
s({ 'n', 'v' }, '2<leader>a', ':call bufferjump#left(2)<cr>', o)
s({ 'n', 'v' }, '2<leader>d', ':call bufferjump#right(2)<cr>', o)
s({ 'n', 'v' }, '3<leader>w', ':call bufferjump#up(3)<cr>', o)
s({ 'n', 'v' }, '3<leader>s', ':call bufferjump#down(3)<cr>', o)
s({ 'n', 'v' }, '3<leader>a', ':call bufferjump#left(3)<cr>', o)
s({ 'n', 'v' }, '3<leader>d', ':call bufferjump#right(3)<cr>', o)
s({ 'n', 'v' }, '4<leader>w', ':call bufferjump#up(4)<cr>', o)
s({ 'n', 'v' }, '4<leader>s', ':call bufferjump#down(4)<cr>', o)
s({ 'n', 'v' }, '4<leader>a', ':call bufferjump#left(4)<cr>', o)
s({ 'n', 'v' }, '4<leader>d', ':call bufferjump#right(4)<cr>', o)
s({ 'n', 'v' }, '5<leader>w', ':call bufferjump#up(5)<cr>', o)
s({ 'n', 'v' }, '5<leader>s', ':call bufferjump#down(5)<cr>', o)
s({ 'n', 'v' }, '5<leader>a', ':call bufferjump#left(5)<cr>', o)
s({ 'n', 'v' }, '5<leader>d', ':call bufferjump#right(5)<cr>', o)
s({ 'n', 'v' }, '6<leader>w', ':call bufferjump#up(6)<cr>', o)
s({ 'n', 'v' }, '6<leader>s', ':call bufferjump#down(6)<cr>', o)
s({ 'n', 'v' }, '6<leader>a', ':call bufferjump#left(6)<cr>', o)
s({ 'n', 'v' }, '6<leader>d', ':call bufferjump#right(6)<cr>', o)
s({ 'n', 'v' }, '7<leader>w', ':call bufferjump#up(7)<cr>', o)
s({ 'n', 'v' }, '7<leader>s', ':call bufferjump#down(7)<cr>', o)
s({ 'n', 'v' }, '7<leader>a', ':call bufferjump#left(7)<cr>', o)
s({ 'n', 'v' }, '7<leader>d', ':call bufferjump#right(7)<cr>', o)
s({ 'n', 'v' }, '8<leader>w', ':call bufferjump#up(8)<cr>', o)
s({ 'n', 'v' }, '8<leader>s', ':call bufferjump#down(8)<cr>', o)
s({ 'n', 'v' }, '8<leader>a', ':call bufferjump#left(8)<cr>', o)
s({ 'n', 'v' }, '8<leader>d', ':call bufferjump#right(8)<cr>', o)
s({ 'n', 'v' }, '9<leader>w', ':call bufferjump#up(9)<cr>', o)
s({ 'n', 'v' }, '9<leader>s', ':call bufferjump#down(9)<cr>', o)
s({ 'n', 'v' }, '9<leader>a', ':call bufferjump#left(9)<cr>', o)
s({ 'n', 'v' }, '9<leader>d', ':call bufferjump#right(9)<cr>', o)
EOF
