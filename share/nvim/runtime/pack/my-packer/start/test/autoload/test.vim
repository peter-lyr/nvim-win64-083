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

" echomsg UniquePrefix([ 'nvim-win64-083',  'nvim-web-devicons', ])
