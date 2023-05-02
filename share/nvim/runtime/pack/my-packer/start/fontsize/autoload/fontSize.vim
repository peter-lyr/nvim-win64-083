let s:allow = 1

fu! fontSize#allow()
    let s:allow = 1
endfu

fu! s:echo()
    ec 'GuiFont! Hack\ NFM:h' .string(s:fontsize)
endfu

fu! fontSize#change(bigger)
    if !s:allow
        return
    endif
    let change = 0
    if a:bigger == 1
        if s:fontsize < 63
            let s:fontsize = s:fontsize + 1
            let change = 1
        endif
    elseif a:bigger == -1
        if s:fontsize > 2
            let s:fontsize = s:fontsize - 1
            let change = 1
        endif
    elseif a:bigger == -2
        let s:fontsize = 2
        let change = 1
    else
        let s:fontsize = s:fontsizenormal
        let change = 1
    endif
    if change == 1
        exec 'GuiFont! Hack\ NFM:h' .string(s:fontsize)
        call timer_start(180, { -> <sid>echo() })
    endif
    let s:allow = 0
    call timer_start(100, { -> fontSize#allow() })
endfu

let s:fontsize = 9
let s:fontsizenormal = 9
