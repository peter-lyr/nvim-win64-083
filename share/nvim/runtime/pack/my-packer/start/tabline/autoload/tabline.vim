fu tabline#get_fname(bufname)
  if len(trim(a:bufname)) == 0
    return '+'
  endif
  try
    let project = projectroot#get(a:bufname)
  catch
    let project = a:bufname
  endtry
  let project = substitute(project, '\', '/', 'g')
  let project = split(project, '/')
  if len(project) > 0
    return project[-1]
  endif
  return '-'
endfu

fu tabline#bwwatcher(bufnr)
  if bufnr() != a:bufnr
    call timer_stop(g:tabline_bw_timer)
    try
      exe 'bw' . a:bufnr
    catch
    endtry
  endif
endfu

fu tabline#bw(bufnr)
    if bufnr() == a:bufnr
      try
        exe 'b' . g:nextbufnr
        let g:tabline_bw_timer = timer_start(10, { -> tabline#bwwatcher(a:bufnr) }, { 'repeat': -1})
      catch
      endtry
    else
      call tabline#bwwatcher(a:bufnr)
    endif
endfu

fu tabline#gobuffer(minwid, _clicks, _btn, _modifiers)
  if a:_clicks == 1 && a:_btn == 'l'
    exe 'b' . a:minwid
  elseif a:_clicks == 2 && a:_btn == 'm'
    call tabline#bw(a:minwid)
  endif
endfu

let g:process_mem = ''
let g:tabline_exts = {}

fu tabline#tabline()
  let s = ''
  let curname = substitute(nvim_buf_get_name(0), '\', '/', 'g')
  let curbufnr = bufnr()
  let cwd = tolower(substitute(getcwd(), '\', '/', 'g'))
  let cnt = 0
  let curcnt = 0
  let L = {}
  for bufnr in nvim_list_bufs()
    if !buflisted(bufnr) && !nvim_buf_is_loaded(bufnr)
      continue
    endif
    let name = substitute(nvim_buf_get_name(bufnr), '\', '/', 'g')
    if !filereadable(name) || match(tolower(name), cwd) == -1
      continue
    endif
    let names = split(name, '/')
    let name = names[-1]
    if bufnr == curbufnr
      let curcnt = cnt
    else
    endif
    let L[cnt] = [bufnr, name]
    let cnt += 1
  endfor
  let mincnt = max([curcnt - 4, 0])
  let maxcnt = min([curcnt + 4, cnt - 1])
  let cnt = 0
  if !filereadable(curname)
    let curcnt = -1
  endif
  let length = len(L)
  for i in range(mincnt, maxcnt)
    let key = L[i]
    let bufnr = key[0]
    let name = key[1]
    let cnt += 1
    exe 'nnoremap <buffer><silent><nowait> <leader>' . cnt ' :b' . bufnr .'<cr>'
    if i + 1 == curcnt
      exe 'nnoremap <buffer><silent><nowait> <leader>- :b' . L[i][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <c-bs> :b' . L[i][0] .'<cr>'
      if i + 1 == length - 1
        let g:nextbufnr = L[i][0]
      endif
    elseif i - 1 == curcnt
      exe 'nnoremap <buffer><silent><nowait> <leader>= :b' . L[i][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <bs> :b' . L[i][0] .'<cr>'
      let g:nextbufnr = L[i][0]
    endif
    let ext = split(name, '\.')[-1]
    let s ..= '%' . bufnr
    let s ..= '@tabline#gobuffer@'
    if i == curcnt
      let s ..= printf('%%#MyTabline%s#▎', ext)
    else
      let s ..= '%#TabLine#▎'
    endif
    let s ..= printf('%%#MyTabline%s#', ext)
    let s ..= cnt .. ' '
    if i == curcnt && length >= 7
      let s ..= '/'
      let s ..= length
    endif
    if i == curcnt
      let s ..= '%#TabLineSel#'
    else
      let s ..= '%#TabLine#'
    endif
    try
      let ic = g:tabline_exts[ext][0]
      let s ..= join(split(name, '\.')[0:-2], '\.')
      let s ..= printf('%%#MyTabline%s#', ext)
      let s ..= ' ' .. ic
    catch
      let s ..= name
    endtry
    let s ..= ' '
  endfor
  let s = trim(s)
  if length == curcnt + 1
    if index(keys(L), '0') != -1
      exe 'nnoremap <buffer><silent><nowait> <leader>= :b' . L[0][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <bs> :b' . L[0][0] .'<cr>'
    endif
  elseif 0 == curcnt
    if index(keys(L), string(length-1)) != -1
      exe 'nnoremap <buffer><silent><nowait> <leader>- :b' . L[length-1][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <c-bs> :b' . L[length-1][0] .'<cr>'
    endif
  endif
  if len(s) == 0
    let s ..= '%#TabLineSel#'
    let s ..= '%' . curbufnr
    let s ..= '@tabline#gobuffer@'
    let s ..= ' 1 empty name '
  else
    exe 'nnoremap <buffer><silent><nowait> <leader>0 :b' . bufnr .'<cr>'
  endif
  let s ..= '%#TabLineFill#%T'
  let s ..= "%="
  let s ..= '%#Comment#'
  let s ..= "  ("
  let s ..= g:process_mem
  let s ..= ")  "
  let curtabpgnr = tabpagenr()
  for i in range(tabpagenr('$'))
    let buflist = tabpagebuflist(i + 1)
    let winnr = tabpagewinnr(i + 1)
    let bufname = nvim_buf_get_name(buflist[winnr-1])
    let s ..= '%' .. (i + 1) .. 'T'
    try
      let ext = split(bufname, '\.')[-1]
      let s ..= printf('%%#MyTabline%s#', ext)
    catch
    endtry
    let s ..= '▎'
    if i + 1 == curtabpgnr
      let s ..= '%#TabLineSel#'
    else
      let s ..= '%#TabLine#'
    endif
    let s ..= string(i+1)
    let s ..= " %{tabline#get_fname('" .. bufname .. "')} "
  endfor
  return trim(s)
endfu
