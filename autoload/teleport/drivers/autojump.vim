let s:autojump = { 'name': 'autojump' }

func! s:autojump.is_supported() abort
  return executable('autojump') && exists('g:teleport#path')
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
