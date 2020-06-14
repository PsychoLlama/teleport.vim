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

" Command completion.
func! zcd#Completion(args, command, cursor) abort
  if a:args =~# '\v^\s*$'
    return []
  endif

  let l:cmd_pattern = '\v^\s*Z\s*'
  let l:search = substitute(a:command, l:cmd_pattern, '', '')
  let l:args = split(l:search, '\v\s+')

  " Vim completion only works on single arguments, not the whole
  " command. Completing to an absolute path when there's more than
  " one search pattern will prevent any results from showing up.
  " For this reason, no completions are suggested unless exactly
  " one argument is provided.
  if len(l:args) != 1
    return []
  endif

  let l:matches = zcd#api#find_matches(l:search)
  let l:matches = type(l:matches) == v:t_list ? l:matches : []
  call map(l:matches, 'v:val.directory')

  return l:matches
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
