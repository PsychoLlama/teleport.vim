" https://github.com/ajeetdsouza/zoxide
let s:zoxide = { 'name': 'zoxide' }

func! s:zoxide.is_supported() abort
  return executable('zoxide')
endfunc

func! s:zoxide.query(search) abort
  let l:search_term = fnameescape(a:search)
  let l:output = systemlist('zoxide query --list --score ' . l:search_term)

  if v:shell_error
    return []
  endif

  return teleport#parse_output#zoxide(l:output)
endfunc

func! teleport#drivers#zoxide#() abort
  return deepcopy(s:zoxide)
endfunc
