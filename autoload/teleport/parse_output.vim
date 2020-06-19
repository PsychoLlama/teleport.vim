" Sample output:
" 0.5        /absolute/directory/path/oldest
" 12         /absolute/directory/path/newer
" 40         /absolute/directory/path/newest
func! teleport#parse_output#z(output) abort
  let l:results = []

  " Process the list of possible matches.
  for l:line in reverse(a:output)
    if l:line =~# '\v^common:'
      continue
    endif

    let l:index_of_leading_slash = stridx(l:line, '/')

    " Parse each output line into an object.
    let l:result = {}
    let l:result.directory = l:line[(l:index_of_leading_slash):]
    let l:result.frecency = l:line[0:(l:index_of_leading_slash - 1)]
    let l:result.frecency = str2float(l:result.frecency)

    call add(l:results, l:result)
  endfor

  return l:results
endfunc

" Both rupa/z and z.lua emit nearly identical output. At the moment, the
" parser can be shared between both implementations.
func! teleport#parse_output#zlua(output) abort
  return teleport#parse_output#z(a:output)
endfunc

" Sample output (contains duplicates):
" search-term__1__/path/to/result-1
" search-term__2__/path/to/result-2
" search-term__3__/path/to/result-3
" search-term__4__/path/to/result-1
" search-term__5__/path/to/result-2
" search-term__6__/path/to/result-4
func! teleport#parse_output#autojump(search_term, output) abort
  let l:results = []

  for l:line in a:output
    let l:line_without_prefix = l:line[strlen(a:search_term):]
    let [l:rank, l:directory] = split(l:line_without_prefix, '__')
    call add(l:results, { 'frecency': str2float(l:rank), 'directory': l:directory })
  endfor

  call sort(l:results, function('s:order_by_directory_name'))
  call uniq(l:results, function('s:filter_duplicates'))
  call sort(l:results, function('s:order_by_rank'))
  call map(l:results, function('s:set_rank_by_index', [copy(l:results)]))

  return l:results
endfunc

func! s:order_by_directory_name(first, second) abort
  if a:first.directory is# a:second.directory
    return 0
  endif

  return a:first.directory > a:second.directory ? -1 : 1
endfunc

func! s:filter_duplicates(first, second) abort
  return a:first.directory isnot# a:second.directory
endfunc

func! s:order_by_rank(first, second) abort
  return float2nr(a:first.frecency - a:second.frecency)
endfunc

" As you might've noticed, the command doesn't reveal frecency. The best we
" can do is approximate by the order it occurs in search results.
func! s:set_rank_by_index(results, index, result) abort
  let a:result.frecency = len(a:results) - a:index + 0.0
  return a:result
endfunc
