fu! statusline#color()
  hi MyHiLiInActive          gui=NONE guifg=#3a3a3a guibg=NONE

  hi MyHiLiBufNr             gui=NONE guifg=#5781ad guibg=NONE
  hi MyHiLiDate              gui=NONE guifg=#5781ad guibg=NONE
  hi MyHiLiTime              gui=NONE guifg=#2752c9 guibg=NONE
  hi MyHiLiWeek              gui=NONE guifg=#739874 guibg=NONE
  hi MyHiLiFnameHead         gui=NONE guifg=#87a4a2 guibg=NONE
  hi MyHiLiFileFormat        gui=NONE guifg=#968853 guibg=NONE
  hi MyHiLiFileEncoding      gui=NONE guifg=#c77227 guibg=NONE
  hi MyHiLiLineCol           gui=NONE guifg=#87a387 guibg=NONE
  hi MyHiLiBotTop            gui=NONE guifg=#279372 guibg=NONE

  hi MyHiLiFnameTailActive   gui=bold guifg=#ff9933 guibg=NONE
  hi MyHiLiFnameTailInActive gui=NONE guifg=#996633 guibg=NONE

  hi StatusLine              gui=NONE guibg=NONE guifg=NONE
  hi StatusLineNC            gui=NONE guibg=NONE guifg=gray
endfu

call statusline#color()

fu! statusline#mode()
  let ret = get({
        \ 'n':      'NORMAL',
        \ 'i':      'INSERT',
        \ 'R':      'REPLACE',
        \ 'v':      'VISUAL',
        \ 'V':      'V-LINE',
        \ "\<C-v>": 'V-BLOCK',
        \ 'c':      'COMMAND',
        \ 's':      'SELECT',
        \ 'S':      'S-LINE',
        \ "\<C-s>": 'S-BLOCK',
        \ 't':      'TERMINAL'
        \ },
        \ mode(),
        \ ''
        \ )
  if 'INSERT' == ret
    hi MyHiLiMode gui=bold guifg=orange
  elseif 'VISUAL'   == ret
    hi MyHiLiMode gui=bold guifg=yellow
  elseif 'V-LINE'   == ret
    hi MyHiLiMode gui=bold guifg=yellow
  elseif 'V-BLOCK'  == ret
    hi MyHiLiMode gui=bold guifg=yellow
  elseif 'REPLACE' == ret
    hi MyHiLiMode gui=bold guifg=red
  elseif 'TERMINAL' == ret
    hi MyHiLiMode gui=NONE guifg=green
  elseif 'COMMAND' == ret
    hi MyHiLiMode gui=bold guifg=purple
  elseif 'SELECT'   == ret
    hi MyHiLiMode gui=bold guifg=red
  elseif 'S-LINE'   == ret
    hi MyHiLiMode gui=bold guifg=red
  elseif 'S-BLOCK'  == ret
    hi MyHiLiMode gui=bold guifg=red
  else
    hi MyHiLiMode gui=NONE guifg=NONE
  endif
  let ret = '[' . ret . ']'
  return printf("%-10s", ret)
endfu

fu! statusline#bufNr()
  let res = printf('[%d]', bufnr())
  let cnt = len(string(bufnr('$'))) + 2
  return printf(printf('%%%ds', cnt), res)
endfu

fu! s:active()
  let statusline  = '%#MyHiLiMode#%{statusline#mode()}'
  let statusline .= '%#MyHiLiBufNr#' . statusline#bufNr()
  let statusline .= '%#MyHiLiDate# ' . strftime("%Y-%m-%d")
  let statusline .= '%#MyHiLiTime# %{strftime("%T")}'
  let statusline .= '%#MyHiLiWeek# ' . strftime("%a")
  let statusline .= '%#MyHiLiFsize# %{statusline#fileSize(@%)}'
  let statusline .= ' %='
  if len(expand(@%)) < winwidth(0)
    let statusline .= '%#MyHiLiFnameHead#%{statusline#fileAbspathHead(@%)}'
  endif
  let statusline .= '%#MyHiLiFnameTailActive#' . statusline#fileAbspathTail(@%)
  let statusline .= ' %='
  let statusline .= '%#MyHiLiLineCol#%m%r%y'
  let statusline .= '%#MyHiLiFileFormat# %{&ff} '
  let statusline .= '%#MyHiLiFileEncoding# %{"".(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?",B":"")." "}'
  let statusline .= '%#MyHiLiLineCol#%(%4l:%-4c%)'
  let statusline .= '%#MyHiLiBotTop# %P '
  return statusline
endfu

fu! s:inactive()
  let statusline  = '          '
  let statusline .= '%{statusline#bufNr()}'
  let statusline .= '            '
  let statusline .= '         '
  let statusline .= strftime("%a")
  let statusline .= ' %{statusline#fileSize(@%)}'
  let statusline .= ' %='
  let statusline .= '%#MyHiLiFnameHead#%{statusline#fileAbspathHead(@%)}'
  let statusline .= '%#MyHiLiFnameTailInActive#%{statusline#fileAbspathTail(@%)}'
  let statusline .= ' %='
  let statusline .= '%#MyHiLiInActive#%m%r%y'
  let statusline .= ' %{&ff} '
  let statusline .= ' %{"".(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?",B":"")." "}'
  let statusline .= '%(%4l:%-4c%)'
  let statusline .= ' %P '
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
    hi MyHiLiFsize gui=NONE guifg=gray guibg=NONE
    return printf('%6d', l:size) .'B'
  elseif l:size < 1024*1024
    hi MyHiLiFsize gui=NONE guifg=yellow guibg=NONE
    return printf('%3d', l:size/1024) .'.' .split(printf('%.2f', l:size/1024.0), '\.')[-1] .'K'
  elseif l:size < 1024*1024*1024
    hi MyHiLiFsize gui=bold guifg=orange guibg=NONE
    return printf('%3d', l:size/1024/1024) .'.' .split(printf('%.2f', l:size/1024.0/1024.0), '\.')[-1] .'M'
  else
    hi MyHiLiFsize gui=bold guifg=red guibg=NONE
    return printf('%3d', l:size/1024/1024/1024) .'.' .split(printf('%.2f', l:size/1024.0/1024.0/1024.0), '\.')[-1] .'G'
  endif
endfu
