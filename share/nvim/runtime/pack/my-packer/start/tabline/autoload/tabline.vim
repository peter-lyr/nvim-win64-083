fu tabline#get_fname(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bufname = nvim_buf_get_name(buflist[winnr-1])
  if len(trim(bufname)) == 0
    return '+'
  endif
  try
    let project = projectroot#get(bufname)
  catch
    let project = bufname
  endtry
  let project = substitute(project, '\', '/', 'g')
  let project = split(project, '/')
  if len(project) > 0
    return project[-1]
  endif
  return '-'
endfu

fu tabline#gobuffer(minwid, _clicks, _btn, _modifiers)
  exe 'b' . a:minwid
endfu

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
  for i in range(mincnt, maxcnt)
    let key = L[i]
    let bufnr = key[0]
    let name = key[1]
    let cnt += 1
    exe 'nnoremap <buffer><silent><nowait> <leader>' . cnt ' :b' . bufnr .'<cr>'
    if i + 1 == curcnt
      exe 'nnoremap <buffer><silent><nowait> <leader>- :b' . L[i][0] .'<cr>'
    elseif i - 1 == curcnt
      exe 'nnoremap <buffer><silent><nowait> <leader>= :b' . L[i][0] .'<cr>'
    endif
    if i == curcnt
      let s ..= '%#TabLineSel#'
    else
      let s ..= '%#TabLine#'
    endif
    let s ..= '%' . bufnr
    let s ..= '@tabline#gobuffer@'
    let s ..= cnt
    let s ..= ' ' . name . ' '
  endfor
  if len(s) == 0
    let s ..= '%#TabLineSel#'
    let s ..= '%' . curbufnr
    let s ..= '@tabline#gobuffer@'
    let s ..= '1 empty name '
  else
    exe 'nnoremap <buffer><silent><nowait> <leader>0 :b' . bufnr .'<cr>'
  endif
  let s ..= '%#TabLineFill#%T'
  let s ..= "  %="
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s ..= '%#TabLineSel#'
    else
      let s ..= '%#TabLine#'
    endif
    let s ..= '%' .. (i + 1) .. 'T'
    let s ..= string(i+1)
    let s ..= ' %{tabline#get_fname(' .. (i + 1) .. ')} '
  endfor
  return s
endfu
