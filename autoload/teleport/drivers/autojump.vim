let s:autojump = { 'name': 'autojump' }

func! s:autojump.is_supported() abort
  if !executable('autojump') || !exists('g:teleport#path')
    return 0
  endif

  let l:path_matches = fnamemodify(g:teleport#path, ':t') is# 'autojump.sh'
  let l:explicitly_set_driver = get(g:, 'teleport#driver', v:null) is# 'autojump'
  return l:path_matches || l:explicitly_set_driver
endfunc

func! s:autojump.query(search_term) abort
  let l:output = s:exec_query(a:search_term)
  return teleport#parse_output#autojump(a:search_term, l:output)
endfunc

func! teleport#drivers#autojump#() abort
  return deepcopy(s:autojump)
endfunc

func! s:exec_query(search_term) abort
  let l:cmd = 'source ' . fnameescape(g:teleport#path) . '; '
  let l:cmd .= 'autojump --complete ' . fnameescape(a:search_term)

  return systemlist(l:cmd)
endfunc
