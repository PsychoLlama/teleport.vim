let s:deprecation_msg_shown = v:false

" This was listed as a public function in the documentation for a while. It's
" been replaced by a more robust system.
func! zcd#FindMatches(search) abort
  if !s:deprecation_msg_shown
    let s:deprecation_msg_shown = v:true
    echo 'zcd#FindMatches(...) is deprecated. Use teleport#api#find_matches(...) instead.'
  endif
  return teleport#api#find_matches(a:search)
endfunc
