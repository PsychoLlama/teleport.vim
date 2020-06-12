func! s:YellAtSomeone() abort
  throw '"g:zcd#driver" is invalid'
endfunc

func! zcd#driver#load() abort
  let l:driver = get(g:, 'zcd#driver', v:null)

  if l:driver is# 'zoxide'
    return zcd#drivers#zoxide#()
  endif

  if l:driver is# 'test'
    return zcd#drivers#test#()
  endif

  let l:zoxide = zcd#drivers#zoxide#()
  if l:zoxide.Exists()
    return l:zoxide
  endif

  let l:test = zcd#drivers#test#()
  if l:test.Exists()
    return l:test
  endif

  call s:YellAtSomeone()
endfunc
