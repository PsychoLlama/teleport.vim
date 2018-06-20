func! s:RunCommand(...) abort
  let l:Zcd = function('zcd#', a:000)

  " Compatibility with my fancy vim stacktrace parser.
  if exists('*stacktrace#Capture')
    return stacktrace#Capture(l:Zcd)
  endif

  " Peasant version.
  return l:Zcd()
endfunc

command! -nargs=+ Z call s:RunCommand(<f-args>)
