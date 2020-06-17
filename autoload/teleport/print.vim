" Syntax-highlighted echo messages.
func! s:print(highlight_token, messages) abort
  execute 'echohl ' . a:highlight_token
  echon join(a:messages, '')
  echohl None
endfunc

func! teleport#print#error(...) abort
  call s:print('Error', a:000)
endfunc

func! teleport#print#string(...) abort
  call s:print('String', a:000)
endfunc

func! teleport#print#function(...) abort
  call s:print('Function', a:000)
endfunc

func! teleport#print#code(...) abort
  call s:print('Comment', a:000)
endfunc

func! teleport#print#(...) abort
  call s:print('None', a:000)
endfunc
