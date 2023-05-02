fu! tabline#bwwatcher(bufnr)
  if bufnr() != a:bufnr
    try
      call timer_stop(g:tabline_bw_timer)
    catch
    endtry
    try
      exe 'bw' . a:bufnr
      let g:tabline_done = 0
    catch
    endtry
  endif
endfu

fu! tabline#bw(bufnr)
  if bufnr() == a:bufnr
    try
      exe 'b' . g:nextbufnr
      let g:tabline_bw_timer = timer_start(10, { -> tabline#bwwatcher(a:bufnr) }, { 'repeat': -1})
    catch
    endtry
  else
    call tabline#bwwatcher(a:bufnr)
  endif
  let g:tabline_done = 0
endfu

fu! tabline#gobuffer(minwid, _clicks, _btn, _modifiers)
  if a:_clicks == 1 && a:_btn == 'l'
    exe 'b' . a:minwid
  elseif a:_clicks == 2 && a:_btn == 'm'
    call tabline#bw(a:minwid)
  endif
endfu

let g:process_mem = ''
let g:tabline_exts = {}
let g:bwall_dict = {}

fu! tabline#pushdict(name)
  let cwd = tolower(substitute(getcwd(), '\', '/', 'g'))
  if !has_key(g:bwall_dict, cwd)
    let g:bwall_dict[cwd] = [a:name]
  else
    let g:bwall_dict[cwd] += [a:name]
  endif
endfu

fu! tabline#getalldict()
  lua << EOF
    local t1 = {}
    for k, _ in pairs(vim.g.bwall_dict) do
      table.insert(t1, k)
    end
    if #t1 > 0 then
      vim.ui.select(t1, { prompt = 'bwipeout cwd' }, function(choice, _)
      local t2 = {}
        for _, v in pairs(vim.g.bwall_dict[choice]) do
          table.insert(t2, v)
        end
        vim.ui.select(t2, { prompt = 'open' }, function(choice, _)
          vim.cmd(string.format('e %s', choice))
        end)
      end)
    end
EOF
endfu

fu! tabline#getdict()
  let cwd = tolower(substitute(getcwd(), '\', '/', 'g'))
  if has_key(g:bwall_dict, cwd)
    lua << EOF
      local t1 = {}
      local cwd = string.gsub(vim.fn['getcwd'](), '\\', '/')
      cwd = vim.fn['tolower'](cwd)
      for _, v in pairs(vim.g.bwall_dict[cwd]) do
        table.insert(t1, v)
      end
      if #t1 > 0 then
        vim.ui.select(t1, { prompt = 'open' }, function(choice, _)
          vim.cmd(string.format('e %s', choice))
        end)
      end
EOF
  endif
endfu

fu! tabline#bwall()
  let cwd = tolower(substitute(getcwd(), '\', '/', 'g'))
  let cnt = 0
  for bufnr in nvim_list_bufs()
    let name = substitute(nvim_buf_get_name(bufnr), '\', '/', 'g')
    if match(tolower(name), cwd) == -1
      continue
    endif
    if buflisted(bufnr) && nvim_buf_is_loaded(bufnr) && filereadable(name)
      call tabline#pushdict(name)
    endif
    exe 'bw' . bufnr
    let cnt += 1
  endfor
  let g:tabline_done = 0
endfu

function! UniquePrefix(strings)
  let strings = a:strings
  if len(strings) == 1
    return [strings[0][0] . '…']
  endif
  let new_strings = []
  for string in strings
    for i in range(len(string))
      let substring = string[0:i]
      let ok = 0
      for fullstring in strings
        if fullstring == string
          continue
        endif
        if match(fullstring, substring) == 0
          break
        endif
        let ok = 1
      endfor
      if ok
        if substring == string
          let new_strings += [substring]
        else
          let new_strings += [substring . '…']
        endif
        break
      endif
    endfor
    if !ok
      let new_strings += [string]
    endif
  endfor
  return new_strings
endfunction

nnoremap <silent><nowait> <leader>b<a-bs> :call tabline#bwall()<cr>
nnoremap <silent><nowait> <leader>bq :call tabline#getdict()<cr>
nnoremap <silent><nowait> <leader>br :call tabline#getalldict()<cr>

let g:tabline_string = ''
let g:curbufnr = 0
let g:tabline_onesecond = 1
let g:tabline_done = 1

fu! tabline#tabline()
  if g:curbufnr == bufnr() && g:tabpagecnt == tabpagenr() && g:tabline_done
    if g:tabline_onesecond == 0
      return g:tabline_string
    endif
    return substitute(g:tabline_string, '\(#  ([0-9:. ]\+M)  %\)', '#  (' . g:process_mem . 'M)  %', 'g')
  endif
  let g:tabpagecnt = tabpagenr()
  let g:tabline_done = 1
  let g:tabline_onesecond = 0
  let g:curbufnr = bufnr()
  let s = ''
  let curname = substitute(nvim_buf_get_name(0), '\', '/', 'g')
  let cwd = tolower(substitute(getcwd(), '\', '/', 'g'))
  let cnt = 0
  let curcnt = 0
  let L = {}
  for bufnr in nvim_list_bufs()
    if !buflisted(bufnr) && !nvim_buf_is_loaded(bufnr)
      continue
    endif
    let name = substitute(nvim_buf_get_name(bufnr), '\', '/', 'g')
    if !filereadable(name) || match(tolower(name), cwd) == -1 || cwd != tolower(substitute(projectroot#get(name), '\', '/', 'g'))
      continue
    endif
    let names = split(name, '/')
    let name = names[-1]
    if bufnr == g:curbufnr
      let curcnt = cnt
    else
    endif
    let L[cnt] = [bufnr, name]
    let cnt += 1
  endfor
  let mincnt = max([curcnt - 14, 0])
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
    if cnt < 10
      let b1 = cnt
    else
      let b1 = '`' . string(cnt-10)
    endif
    exe 'nnoremap <buffer><silent><nowait> <leader>' . b1 ' :b' . bufnr .'<cr>'
    exe 'nnoremap <buffer><silent><nowait> <leader>b' . b1 ' :call tabline#bw(' . bufnr .')<cr>'
    if i + 1 == curcnt
      exe 'nnoremap <buffer><silent><nowait> <leader>- :b' . L[i][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <leader>b- :call tabline#bw(' . L[i][0] .')<cr>'
      exe 'nnoremap <buffer><silent><nowait> <c-bs> :b' . L[i][0] .'<cr>'
      if i + 1 == length - 1
        let g:nextbufnr = L[i][0]
      endif
    elseif i - 1 == curcnt
      exe 'nnoremap <buffer><silent><nowait> <leader>= :b' . L[i][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <leader>b= :call tabline#bw(' . L[i][0] .')<cr>'
      exe 'nnoremap <buffer><silent><nowait> <bs> :b' . L[i][0] .'<cr>'
      let g:nextbufnr = L[i][0]
    elseif i == curcnt
      exe 'nnoremap <buffer><silent><nowait> <leader>b<bs> :call tabline#bw(' . bufnr .')<cr>'
    endif
    let ext = split(name, '\.')[-1]
    let s ..= '%' . bufnr
    let s ..= '@tabline#gobuffer@'
    if i == curcnt
      let s ..= printf('%%#MyTabline%s#▎', ext)
      let s ..= cnt
    else
      let s ..= '%#TablineDim#▎'
      let s ..= cnt
    endif
    if i == curcnt && length >= 7
      let s ..= '/'
      let s ..= length
    endif
    let s ..= ' '
    if i != curcnt
      let s ..= '%#TablineDim#'
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
      exe 'nnoremap <buffer><silent><nowait> <leader>b= :call tabline#bw(' . L[0][0] .')<cr>'
      exe 'nnoremap <buffer><silent><nowait> <bs> :b' . L[0][0] .'<cr>'
    endif
  elseif 0 == curcnt
    if index(keys(L), string(length-1)) != -1
      exe 'nnoremap <buffer><silent><nowait> <leader>- :b' . L[length-1][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <leader>b- :call tabline#bw(' . L[length-1][0] .')<cr>'
      exe 'nnoremap <buffer><silent><nowait> <c-bs> :b' . L[length-1][0] .'<cr>'
    endif
  endif
  if len(s) == 0
    let s ..= '%#TablineDim#'
    let s ..= '%' . g:curbufnr
    let s ..= '@tabline#gobuffer@'
    let s ..= ' 1 empty name '
  else
    exe 'nnoremap <buffer><silent><nowait> <leader>0 :b' . bufnr .'<cr>'
    exe 'nnoremap <buffer><silent><nowait> <leader>b0 :call tabline#bw(' . bufnr .')<cr>'
  endif
  let s ..= '%#TablineDim#%T'
  let s ..= "%="
  let s ..= '%#TablineDim#'
  let s ..= "  ("
  let s ..= g:process_mem
  let s ..= "M)  "
  let projectroots = []
  let curtabpgnr = tabpagenr()
  for i in range(tabpagenr('$'))
    let buflist = tabpagebuflist(i + 1)
    let winnr = tabpagewinnr(i + 1)
    let bufname = nvim_buf_get_name(buflist[winnr-1])
    if i + 1 == curtabpgnr
      let curtabpageidx = i
      try
        let curext = split(bufname, '\.')[-1]
      catch
      endtry
    endif
    if len(trim(bufname)) == 0
      let projectroots += ['+']
    else
      try
        let project = projectroot#get(bufname)
      catch
        let project = bufname
      endtry
      let project = substitute(project, '\', '/', 'g')
      let project = split(project, '/')
      if len(project) > 0
        let projectroots += [project[-1]]
      else
        let projectroots += ['-']
      endif
    endif
  endfor
  let curprojectroot = projectroots[curtabpageidx]
  let projectroots = UniquePrefix(projectroots)
  for i in range(len(projectroots))
    let projectroot = projectroots[i]
    let s ..= '%' .. (i + 1) .. 'T'
    if i == curtabpageidx
      try
        let s ..= printf('%%#MyTabline%s#', curext)
      catch
      endtry
    else
      let s ..= '%#TablineDim#'
    endif
    let s ..= '▎'
    let s ..= string(i+1) . ' '
    if i == curtabpageidx
      let s ..= curprojectroot
    else
      let s ..= projectroot
    endif
    let s ..= ' '
  endfor
  let g:tabline_string = trim(s)
  return g:tabline_string
endfu
