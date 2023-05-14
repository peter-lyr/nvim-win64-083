fu! tabline#bwwatcher(bufnr)
  if bufnr() != a:bufnr
    try
      call timer_stop(g:tabline_bw_timer)
    catch
    endtry
    try
      if getbufvar(a:bufnr, '&readonly') != 1
        call tabline#pushdict(nvim_buf_get_name(a:bufnr))
        exe 'bw' . a:bufnr
        let g:tabline_done = 0
      endif
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
let s:showtablineright = 1

fu! tabline#pushdict(name)
  let name = tolower(substitute(a:name, '\', '/', 'g'))
  let cwd = tolower(substitute(getcwd(), '\', '/', 'g'))
  if !has_key(g:bwall_dict, cwd)
    let g:bwall_dict[cwd] = [name]
  else
    if index(g:bwall_dict[cwd], name) == -1
      let g:bwall_dict[cwd] += [name]
    endif
  endif
endfu

fu! tabline#openbwprojects()
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

function! tabline#updatedict(cwd, names)
  let g:bwall_dict[a:cwd] = a:names
endfunction

fu! tabline#openbw()
  let cwd = tolower(substitute(getcwd(), '\', '/', 'g'))
  if has_key(g:bwall_dict, cwd)
    lua << EOF
      local t1 = {}
      local cwd = string.gsub(vim.fn['getcwd'](), '\\', '/')
      cwd = vim.fn['tolower'](cwd)
      for _, v in pairs(vim.g.bwall_dict[cwd]) do
        if vim.fn['filereadable'](v) == 1 then
          table.insert(t1, v)
        end
      end
      if #t1 > 0 then
        vim.ui.select(t1, { prompt = 'open' }, function(_, index)
          vim.cmd(string.format('e %s', t1[index]))
          table.remove(t1, index)
          vim.fn['tabline#updatedict'](cwd, t1)
        end)
      end
EOF
  endif
endfu

fu! tabline#bwallcurprojects()
  let cwd = tolower(substitute(getcwd(), '\', '/', 'g'))
  for bufnr in nvim_list_bufs()
    let name = substitute(nvim_buf_get_name(bufnr), '\', '/', 'g')
    if name == '' || match(tolower(name), cwd) == -1
      continue
    endif
    if buflisted(bufnr) && nvim_buf_is_loaded(bufnr) && filereadable(name)
      if getbufvar(bufnr, '&readonly') != 1
        call tabline#pushdict(name)
      endif
    endif
    exe 'bw!' . bufnr
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
    let ok = 1
    let substrings = []
    for ch in string
      if len(substrings) == 0
        let substrings += [ch]
      else
        let substrings += [substrings[-1] . ch]
      endif
    endfor
    let yes = 0
    for substring in substrings
      if substring == string || yes
        if substring == string
          let new_strings += [substring]
        else
          let new_strings += [substring . '…']
        endif
        break
      endif
      let ok = 1
      for fullstring in strings
        if fullstring == string
          continue
        endif
        if match(fullstring, substring) == 0
          let ok = 0
          break
        endif
      endfor
      if ok
        if substring == string
          let new_strings += [substring]
        else
          let yes = 1
          continue
          " let new_strings += [substring . '…']
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

nnoremap <silent><nowait> <leader>xC :call tabline#bwallcurprojects()<cr>
nnoremap <silent><nowait> <leader>bq :call tabline#openbw()<cr>
nnoremap <silent><nowait> <leader>br :call tabline#openbwprojects()<cr>

let s:tabline_string = ''
let s:curbufnr = 0
let g:tabline_onesecond = 1
let g:tabline_done = 1

let s:cnt = 19

fu! tabline#tabline()
  if s:curbufnr == bufnr() && g:tabpagecnt == tabpagenr() && g:tabline_done
    if g:tabline_onesecond == 0
      return s:tabline_string
    endif
    return substitute(s:tabline_string, '\(#  ([0-9:. %-]\+M)  %\)', '#  (' . g:process_mem . 'M)  %', 'g')
  endif
  let g:tabpagecnt = tabpagenr()
  let g:tabline_done = 1
  let g:tabline_onesecond = 0
  let s:curbufnr = bufnr()
  let curname = substitute(nvim_buf_get_name(0), '\', '/', 'g')
  let cwd = tolower(substitute(getcwd(), '\', '/', 'g'))
  let cnt = 0
  let curcnt = 0
  let L = {}
  for i in range(s:cnt)
    if i + 1 < 10
      let b1 = i + 1
    else
      let b1 = '`' . string(i + 1 - 10)
    endif
    try
      exe 'unmap <buffer> <leader>' . b1
      exe 'unmap <buffer> <leader>x' . b1
    catch
    endtry
  endfor
  for bufnr in nvim_list_bufs()
    if !buflisted(bufnr) && !nvim_buf_is_loaded(bufnr)
      continue
    endif
    let name = substitute(nvim_buf_get_name(bufnr), '\', '/', 'g')
    if name == '' || !filereadable(name) || match(tolower(name), cwd) == -1 || cwd != tolower(substitute(projectroot#get(name), '\', '/', 'g'))
      continue
    endif
    let names = split(name, '/')
    let name = names[-1]
    if bufnr == s:curbufnr
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
  let s1 = ''
  let S1 = []
  for i in range(mincnt, maxcnt)
    let temps1 = ''
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
    exe 'nnoremap <buffer><silent><nowait> <leader>x' . b1 ' :call tabline#bw(' . bufnr .')<cr>'
    if i + 1 == curcnt
      exe 'nnoremap <buffer><silent><nowait> <leader>- :b' . L[i][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <c-h> :b' . L[i][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <leader>x- :call tabline#bw(' . L[i][0] .')<cr>'
      exe 'nnoremap <buffer><silent><nowait> <c-bs> :b' . L[i][0] .'<cr>'
      if i + 1 == length - 1
        let g:nextbufnr = L[i][0]
      endif
    elseif i - 1 == curcnt
      exe 'nnoremap <buffer><silent><nowait> <leader>= :b' . L[i][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <c-l> :b' . L[i][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <leader>x= :call tabline#bw(' . L[i][0] .')<cr>'
      exe 'nnoremap <buffer><silent><nowait> <bs> :b' . L[i][0] .'<cr>'
      let g:nextbufnr = L[i][0]
    elseif i == curcnt
      exe 'nnoremap <buffer><silent><nowait> <leader>x<bs> :call tabline#bw(' . bufnr .')<cr>'
    endif
    let ext = split(name, '\.')[-1]
    let temps1 ..= '%' . bufnr
    let temps1 ..= '@tabline#gobuffer@'
    if i == curcnt
      let temps1 ..= printf('%%#MyTabline%s#▎', ext)
      let temps1 ..= cnt
    else
      let temps1 ..= '%#TablineDim#▎'
      let temps1 ..= cnt
    endif
    if i == curcnt && length >= 7
      let temps1 ..= '/'
      let temps1 ..= length
    endif
    let temps1 ..= ' '
    if i != curcnt
      let temps1 ..= '%#TablineDim#'
    endif
    try
      let ic = g:tabline_exts[ext][0]
      let temps1 ..= join(split(name, '\.')[0:-2], '\.')
      let temps1 ..= printf('%%#MyTabline%s#', ext)
      let temps1 ..= ' ' .. ic
    catch
      let temps1 ..= name
    endtry
    let temps1 ..= ' '
    let s1 ..= temps1
    let temps1 = substitute(temps1, '%\d\{-}@tabline#gobuffer@', '', 'g')
    let temps1 = substitute(temps1, '%#.\{-}#', '', 'g')
    let S1 += [temps1]
  endfor
  let s:cnt = cnt
  let s1 = trim(s1)
  if length == curcnt + 1
    if index(keys(L), '0') != -1
      exe 'nnoremap <buffer><silent><nowait> <leader>= :b' . L[0][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <c-l> :b' . L[0][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <leader>x= :call tabline#bw(' . L[0][0] .')<cr>'
      exe 'nnoremap <buffer><silent><nowait> <bs> :b' . L[0][0] .'<cr>'
    endif
  elseif 0 == curcnt
    if index(keys(L), string(length-1)) != -1
      exe 'nnoremap <buffer><silent><nowait> <leader>- :b' . L[length-1][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <c-h> :b' . L[length-1][0] .'<cr>'
      exe 'nnoremap <buffer><silent><nowait> <leader>x- :call tabline#bw(' . L[length-1][0] .')<cr>'
      exe 'nnoremap <buffer><silent><nowait> <c-bs> :b' . L[length-1][0] .'<cr>'
    endif
  endif
  if len(s1) == 0
    let s1 ..= '%#TablineDim#'
    let s1 ..= '%' . s:curbufnr
    let s1 ..= '@tabline#gobuffer@'
    let s1 ..= ' 1 empty name '
  else
    exe 'nnoremap <buffer><silent><nowait> <leader>0 :b' . bufnr .'<cr>'
    exe 'nnoremap <buffer><silent><nowait> <leader>x0 :call tabline#bw(' . bufnr .')<cr>'
  endif
  let s1 ..= '%#TablineDim#%T'
  let s1 ..= "%="
  let s1 ..= '%#TablineDim#'
  let s2 = ''
  if s:showtablineright
    let s2 ..= "  ("
    let s2 ..= g:process_mem
    let s2 ..= "M)  "
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
      let buflist = tabpagebuflist(i + 1)
      let winnr = tabpagewinnr(i + 1)
      let bufname = nvim_buf_get_name(buflist[winnr-1])
      try
        let ext = split(bufname, '\.')[-1]
        let s2 ..= printf('%%#MyTabline%s#', ext)
      catch
        let s2 ..= '%#TablineDim#'
      endtry
      try
      catch
      endtry
      let s2 ..= '▎'
      let projectroot = projectroots[i]
      let s2 ..= '%' .. (i + 1) .. 'T'
      if i == curtabpageidx
        try
          let s2 ..= printf('%%#MyTabline%s#', curext)
        catch
          let s2 ..= '%#TablineDim#'
        endtry
      else
        let s2 ..= '%#TablineDim#'
      endif
      let s2 ..= string(i+1) . ' '
      if i == curtabpageidx
        let s2 ..= curprojectroot
      else
        let s2 ..= projectroot
      endif
      let s2 ..= ' '
    endfor
  else
    let s2 ..= printf("  %d/%d", tabpagenr(), tabpagenr('$'))
  endif
  let temps2 = substitute(s2, '%#.\{-}#', '', 'g')
  let temps2 = substitute(temps2, '%\d\{-}T', '', 'g')
  let temps2 = temps2 . ' '
  let s = s1 .. s2
  let s:tabline_string = trim(s) . ' '
  return s:tabline_string
endfu

fu! tabline#restorehiddenprojects()
  let projectroots = []
  let projectrootstemp = []
  for bufnr in nvim_list_bufs()
    if !buflisted(bufnr) && !nvim_buf_is_loaded(bufnr)
      continue
    endif
    let name = substitute(nvim_buf_get_name(bufnr), '\', '/', 'g')
    if name == '' || !filereadable(name)
      continue
    endif
    if getbufvar(bufnr, '&readonly') == 1
      continue
    endif
    let projectroot = tolower(substitute(projectroot#get(name), '\', '/', 'g'))
    if len(name) > 0 && index(projectrootstemp, projectroot) == -1
      let projectroots += [[projectroot, name]]
      let projectrootstemp += [projectroot]
    endif
  endfor
  let curtabpagenr = tabpagenr()
  for i in range(tabpagenr('$'))
    let buflist = tabpagebuflist(i + 1)
    let winnr = tabpagewinnr(i + 1)
    let bufname = nvim_buf_get_name(buflist[winnr-1])
    try
      let projectroot = tolower(substitute(projectroot#get(bufname), '\', '/', 'g'))
      let idx = index(projectrootstemp, projectroot)
      if idx != -1
        call remove(projectroots, idx)
        call remove(projectrootstemp, idx)
      endif
    catch
      continue
    endtry
  endfor
  let openprojects = []
  let tocloseprojects = []
  for i in range(tabpagenr('$'))
    let buflist = tabpagebuflist(i + 1)
    let winnr = tabpagewinnr(i + 1)
    let bufname = nvim_buf_get_name(buflist[winnr-1])
    try
      let projectroot = tolower(substitute(projectroot#get(bufname), '\', '/', 'g'))
      let idx = index(openprojects, projectroot)
      if idx == -1
        let openprojects += [projectroot]
      else
        if index(tocloseprojects, i + 1) == -1
          let tocloseprojects += [i + 1]
        endif
      endif
    catch
    endtry
  endfor
  for proj in tocloseprojects
    exe printf("tabclose %d", proj)
  endfor
  exe 'norm ' . string(tabpagenr('$')) . "gt"
  for projectroot in projectroots
    tabnew
    exe printf("e %s", projectroot[1])
  endfor
  let g:tabline_done = 0
  try
    exe 'norm ' . string(curtabpagenr) . "gt"
  catch
  endtry
endfu

let datadir = expand("$VIMRUNTIME") . "\\my-neovim-data"

if !isdirectory(datadir)
  call mkdir(datadir)
endif

let sessiondir = datadir . "\\Session"
if !isdirectory(sessiondir)
  call mkdir(sessiondir)
endif

let s:sessionname = sessiondir . "\\session.txt"

fu! tabline#savesession()
  let names = []
  for bufnr in nvim_list_bufs()
    if !buflisted(bufnr) && !nvim_buf_is_loaded(bufnr)
      continue
    endif
    if getbufvar(bufnr, '&readonly') == 1
      continue
    endif
    let name = substitute(nvim_buf_get_name(bufnr), '\', '/', 'g')
    if name == '' || !filereadable(name)
      continue
    endif
    let names += [name]
  endfor
  if len(names) > 0
    call writefile(names, s:sessionname)
  endif
endfu

fu! tabline#restoresession()
  let lines = readfile(s:sessionname)
  for line in lines
    if filereadable(line)
      exe 'e ' . line
    endif
  endfor
  call tabline#restorehiddenprojects()
endfu

fu! tabline#toggleshowtabline()
  if &showtabline == 0
    set showtabline=2
  else
    set showtabline=0
  endif
endfu

fu! tabline#toggleshowtablineright()
  let g:tabline_done = 0
  if s:showtablineright
    let s:showtablineright = 0
  else
    let s:showtablineright = 1
  endif
endfu

fu! tabline#bwothers()
  let cwd = tolower(substitute(getcwd(), '\', '/', 'g'))
  for bufnr in nvim_list_bufs()
    let name = substitute(nvim_buf_get_name(bufnr), '\', '/', 'g')
    if name == '' || match(tolower(name), cwd) == -1 || bufnr == s:curbufnr
      continue
    endif
    if buflisted(bufnr) && nvim_buf_is_loaded(bufnr) && filereadable(name)
      if getbufvar(bufnr, '&readonly') != 1
        call tabline#pushdict(name)
      endif
      exe 'bw!' . bufnr
    endif
  endfor
  let g:tabline_done = 0
  let s:cnt = 19
endfu

fu! tabline#bwright()
  let cwd = tolower(substitute(getcwd(), '\', '/', 'g'))
  for bufnr in nvim_list_bufs()
    if bufnr <= s:curbufnr
      continue
    endif
    let name = substitute(nvim_buf_get_name(bufnr), '\', '/', 'g')
    if name == '' || match(tolower(name), cwd) == -1
      continue
    endif
    if buflisted(bufnr) && nvim_buf_is_loaded(bufnr) && filereadable(name)
      if getbufvar(bufnr, '&readonly') != 1
        call tabline#pushdict(name)
      endif
      exe 'bw!' . bufnr
    endif
  endfor
  let g:tabline_done = 0
  let s:cnt = 19
endfu

fu! tabline#bwleft()
  let cwd = tolower(substitute(getcwd(), '\', '/', 'g'))
  for bufnr in nvim_list_bufs()
    if bufnr >= s:curbufnr
      break
    endif
    let name = substitute(nvim_buf_get_name(bufnr), '\', '/', 'g')
    if name == '' || match(tolower(name), cwd) == -1
      continue
    endif
    if buflisted(bufnr) && nvim_buf_is_loaded(bufnr) && filereadable(name)
      if getbufvar(bufnr, '&readonly') != 1
        call tabline#pushdict(name)
      endif
      exe 'bw!' . bufnr
    endif
  endfor
  let g:tabline_done = 0
  let s:cnt = 19
endfu

fu! BwFileType(A, L, P)
  return s:fts
endfu

command! -complete=customlist,BwFileType -nargs=* BwFileType call tabline#bwfiletypedo('<args>')

fu! tabline#bwfiletype()
  let cwd = tolower(substitute(getcwd(), '\', '/', 'g'))
  let s:fts = []
  for bufnr in nvim_list_bufs()
    let name = substitute(nvim_buf_get_name(bufnr), '\', '/', 'g')
    if name == '' || match(tolower(name), cwd) == -1 || bufnr == s:curbufnr
      continue
    endif
    if nvim_buf_is_loaded(bufnr) && filereadable(name)
      let ft = split(split(name, '/')[-1], '\.')[-1]
      if index(s:fts, ft) == -1
        let s:fts += [ft]
      endif
    endif
  endfor
  if len(s:fts) == 0
    echomsg 'no other filetypes to bw'
    return
  endif
  call feedkeys(":\<c-u>BwFileType ")
endfu

fu! tabline#bwfiletypedo(ft)
  let ft = split(trim(tolower(substitute(a:ft, '\s\+', ' ', 'g'))), ' ')
  let cwd = tolower(substitute(getcwd(), '\', '/', 'g'))
  for bufnr in nvim_list_bufs()
    let name = substitute(nvim_buf_get_name(bufnr), '\', '/', 'g')
    if name == '' || match(tolower(name), cwd) == -1 || bufnr == s:curbufnr
      continue
    endif
    if nvim_buf_is_loaded(bufnr) && filereadable(name)
      if index(ft, split(split(name, '/')[-1], '\.')[-1]) != -1
        if getbufvar(bufnr, '&readonly') != 1
          call tabline#pushdict(name)
        endif
        exe 'bw!' . bufnr
      endif
    endif
  endfor
  let g:tabline_done = 0
  let s:cnt = 19
endfu
