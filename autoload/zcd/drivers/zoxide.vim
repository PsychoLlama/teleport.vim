" https://github.com/ajeetdsouza/zoxide
let s:zoxide = { 'name': 'zoxide' }

func! s:zoxide.is_supported() abort
  return executable('zoxide')
endfunc

func! s:zoxide.query(...) abort
  let l:substrings = copy(a:000)
  call map(l:substrings, 'fnameescape(v:val)')

  let [l:result] = systemlist('zoxide query ' . join(l:substrings, ' '))

  if v:shell_error
    return []
  endif

  " TODO: Support multiple results when '--score' ships (4b5f2e7)
  return [{ 'frecency': -1, 'directory': l:result }]
endfunc

func! zcd#drivers#zoxide#() abort
  return deepcopy(s:zoxide)
endfunc
