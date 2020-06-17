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
