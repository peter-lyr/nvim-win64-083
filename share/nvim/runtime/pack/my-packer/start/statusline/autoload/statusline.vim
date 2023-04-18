fu! statusline#color()
  hi MyGroup0  gui=NONE guifg=#3a3a3a guibg=NONE

  hi MyGroup1  gui=NONE guifg=NONE    guibg=NONE
  hi MyGroup2  gui=NONE guifg=gray    guibg=NONE
  hi MyGroup3  gui=NONE guifg=yellow  guibg=NONE
  hi MyGroup4  gui=NONE guifg=#67813d guibg=NONE
  hi MyGroup5  gui=NONE guifg=#277279 guibg=NONE
  hi MyGroup6  gui=NONE guifg=#739874 guibg=NONE
  hi MyGroup7  gui=NONE guifg=#923784 guibg=NONE
  hi MyGroup8  gui=NONE guifg=#87a4a2 guibg=NONE
  hi MyGroup9  gui=NONE guifg=#7890d3 guibg=NONE
  hi MyGroup10 gui=NONE guifg=#668853 guibg=NONE
  hi MyGroup11 gui=NONE guifg=#c77227 guibg=NONE
  hi MyGroup12 gui=NONE guifg=#87a387 guibg=NONE
  hi MyGroup13 gui=NONE guifg=#279372 guibg=NONE
  hi MyGroup15 gui=bold guifg=#ff9933 guibg=NONE
  hi MyGroup16 gui=NONE guifg=#996633 guibg=NONE

  hi StatusLine   gui=NONE guibg=NONE guifg=NONE
  hi StatusLineNC gui=NONE guibg=NONE guifg=gray
endfu

call statusline#color()

fu! statusline#mode()
  let ret = get({
        \ 'n':      'NORMAL ',
        \ 'i':      'INSERT ',
        \ 'R':      'REPLACE',
        \ 'v':      'VISUAL ',
        \ 'V':      'VISUAL ',
        \ "\<C-v>": 'V-BLOCK',
        \ 'c':      'COMMAND',
        \ 's':      'SELECT ',
        \ 'S':      'S-LINE ',
        \ "\<C-s>": 'S-BLOCK',
        \ 't':      'TERMINAL'
        \ },
        \ mode(),
        \ ''
        \ )
  if 'INSERT ' == ret
    hi MyGroup1 gui=bold guifg=orange guibg=NONE
  elseif 'REPLACE' == ret
    hi MyGroup1 gui=bold guifg=red guibg=NONE
  else
    hi MyGroup1 gui=NONE guifg=NONE guibg=NONE
  endif
  return ret
endfu

fu! statusline#bufNr()
  let res = printf('[%d]', bufnr())
  return printf('%5s', res)
endfu

fu! s:active()
  let statusline  = '%#MyGroup1#[%{statusline#mode()}]%*'
  let statusline .= '%#MyGroup2#%{statusline#bufNr()}%*'
  let statusline .= '%#MyGroup4# %{strftime("%Y-%m-%d")} %*'
  let statusline .= '%#MyGroup5# %{strftime("%T")} %*'
  let statusline .= '%#MyGroup6# %{strftime("%a")}%*'
  let statusline .= '%#MyGroup3# %{statusline#fileSize(@%)}%*'
  let statusline .= '%='
  if len(statusline#fileAbspathHead(@%)) + len(statusline#fileAbspathTail(@%)) < winwidth(0)
    let statusline .= '%#MyGroup8#%{statusline#fileAbspathHead(@%)}%*'
  endif
  let statusline .= '%#MyGroup15#%{statusline#fileAbspathTail(@%)} %*'
  let statusline .= '%='
  let statusline .= '%#MyGroup9#%m%r%y%*'
  let statusline .= '%#MyGroup10# %{&ff} %*'
  let statusline .= '%#MyGroup11# %{"".(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?",B":"")." "}%*'
  let statusline .= '%#MyGroup12#%(%4l:%-4c%)%*'
  let statusline .= '%#MyGroup13# %P %*'
  return statusline
endfu

fu! s:inactive()
  let statusline  = '%#MyGroup0#[%{statusline#mode()}]%*'
  let statusline .= '%#MyGroup0#%{statusline#bufNr()}%*'
  let statusline .= '%#MyGroup0# %{strftime("%Y-%m-%d")} %*'
  let statusline .= '%#MyGroup0#          %*'
  let statusline .= '%#MyGroup0# %{strftime("%a")}%*'
  let statusline .= '%#MyGroup0# %{statusline#fileSize(@%)}%*'
  let statusline .= '%='
  let statusline .= '%#MyGroup8# %{statusline#fileAbspathHead(@%)}%*'
  let statusline .= '%#MyGroup16#%{statusline#fileAbspathTail(@%)} %*'
  let statusline .= '%='
  let statusline .= '%#MyGroup0#%m%r%y%*'
  let statusline .= '%#MyGroup0# %{&ff} %*'
  let statusline .= '%#MyGroup0# %{"".(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?",B":"")." "}%*'
  let statusline .= '%#MyGroup0#%(%4l:%-4c%)%*'
  let statusline .= '%#MyGroup0# %P %*'
  return statusline
endfu

fu! statusline#watch()
  let curbufnr = bufnr()
  for wn in range(1, winnr('$'))
    if curbufnr != winbufnr(wn)
      call setwinvar(wn, '&statusline', <sid>inactive())
    else
      call setwinvar(wn, '&statusline', <sid>active())
    endif
  endfor
endfu

fu! statusline#fileAbspathHead(fname)
  let fname = substitute(a:fname, '\', '/', 'g')
  let f = split(fname, '/')
  if len(f) <= 1
    return ''
  endif
  return join(f[:-2], '/') .'/'
endfu

fu! statusline#fileAbspathTail(fname)
  let fname = substitute(a:fname, '\', '/', 'g')
  let f = split(fname, '/')
  if len(f) == 0
    return ''
  endif
  return f[-1]
endfu

fu! statusline#fileSize(fname)
  let l:size = getfsize(expand(a:fname))
  if l:size == 0 || l:size == -1 || l:size == -2
    return '        '
  endif
  if l:size < 1024
    hi MyGroup3 gui=NONE guifg=gray guibg=NONE
    return printf('%6d', l:size) .'B '
  elseif l:size < 1024*1024
    hi MyGroup3 gui=NONE guifg=yellow guibg=NONE
    return printf('%3d', l:size/1024) .'.' .split(printf('%.2f', l:size/1024.0), '\.')[-1] .'K '
  elseif l:size < 1024*1024*1024
    hi MyGroup3 gui=bold guifg=orange guibg=NONE
    return printf('%3d', l:size/1024/1024) .'.' .split(printf('%.2f', l:size/1024.0/1024.0), '\.')[-1] .'M '
  else
    hi MyGroup3 gui=bold guifg=red guibg=NONE
    return printf('%3d', l:size/1024/1024/1024) .'.' .split(printf('%.2f', l:size/1024.0/1024.0/1024.0), '\.')[-1] .'G '
  endif
endfu

fu! statusline#timerUpdate(timer)
  let &ro = &ro
endfu
