" Syntax-highlighted echo messages.
func! s:print(highlight_token, messages) abort
  execute 'echohl ' . a:highlight_token
  echon join(a:messages, '')
  echohl None
endfunc

func! zcd#print#error(...) abort
  call s:print('Error', a:000)
endfunc

func! zcd#print#string(...) abort
  call s:print('String', a:000)
endfunc

func! zcd#print#code(...) abort
  call s:print('Comment', a:000)
endfunc

func! zcd#print#(...) abort
  call s:print('None', a:000)
endfunc
