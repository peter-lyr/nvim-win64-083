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

fu tabline#tabline()
  let s = ''
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s ..= '%#TabLineSel#'
    else
      let s ..= '%#TabLine#'
    endif
    let s ..= '%' .. (i + 1) .. 'T'
    let s ..= string(i+1)
    let s ..= ')%{tabline#get_fname(' .. (i + 1) .. ')} '
  endfor
  let s ..= '%#TabLineFill#%T'
  if tabpagenr('$') > 1
    let s ..= "%=%#TabLine#[%{tabpagenr('$')}]"
  endif
  return s
endfu
