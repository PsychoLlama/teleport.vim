" Return all matches (highest rated to least likely).
func! zcd#api#find_matches(search_term) abort
  let l:driver = zcd#driver#load()

  " Invalid driver settings. Assume an error was reported and fail gracefully.
  return l:driver is# v:null ? 'ERROR' : l:driver.query(a:search_term)
endfunc

" Return the first match.
func! zcd#api#find_match(search_term) abort
  let l:results = zcd#api#find_matches(a:search_term)
  if l:results is# 'ERROR' | return 'ERROR' | endif

  return len(l:results) ? l:results[0] : v:null
endfunc

" Treat well-known symbols specially (e.g. '~' or '%:h').
" Possible feature: expand environment variables before calling the driver.
func! zcd#api#query(search_term) abort
  let l:trimmed_search = trim(a:search_term)
  if l:trimmed_search is# '~' || l:trimmed_search[0] is# '%'
    return expand(l:trimmed_search)
  endif

  let l:result = zcd#api#find_match(a:search_term)
  if l:result is# 'ERROR' | return 'ERROR' | endif

  return l:result is# v:null ? v:null : l:result.directory
endfunc
