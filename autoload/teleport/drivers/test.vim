" A mock driver written purely for testing.
let s:test = { 'name': 'test' }

func! s:test.is_supported() abort
  return get(g:, 'teleport#test_driver#is_supported', v:false)
endfunc

func! s:test.query(...) abort
  return get(g:, 'teleport#test_driver#results', [])
endfunc

func! teleport#drivers#test#() abort
  return deepcopy(s:test)
endfunc
