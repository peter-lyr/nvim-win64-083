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

fu tabline#gobuffer(minwid, _clicks, _btn, _modifiers)
  exe 'b' . a:minwid
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
    elseif i - 1 == curcnt
      exe 'nnoremap <buffer><silent><nowait> <leader>= :b' . L[i][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <bs> :b' . L[i][0] .'<cr>'
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
    let s ..= name .. ' '
    try
      let ic = g:tabline_exts[ext][0]
      let s ..= printf('%%#MyTabline%s#', ext)
      let s ..= ic
    catch
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
