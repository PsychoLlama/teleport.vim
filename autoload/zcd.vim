" Invoked by :Z ...
func! zcd#(...) abort
  let l:search = join(a:000, ' ')
  let l:match = zcd#api#query(l:search)

  " Error state. Assume it was already echoed.
  if l:match is# 'ERROR' | return | endif

  " No luck. Alert the user.
  if l:match is# v:null
    call zcd#print#error('No matches:')
    call zcd#print#(' ', l:search)
    return v:null
  endif

  " Open the most probable match in the current pane.
  execute 'edit ' . fnameescape(l:match)
endfunc

let s:deprecation_msg_shown = v:false

" This was listed as a public function in the documentation for a while. It's
" been replaced by a more robust system.
func! zcd#FindMatches(search) abort
  if !s:deprecation_msg_shown
    let s:deprecation_msg_shown = v:true
    echo 'zcd#FindMatches(...) is deprecated. Use zcd#api#find_matches(...) instead.'
  endif
  return zcd#api#find_matches(a:search)
endfunc
