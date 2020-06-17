" Completion for the `:Z ...` command.
func! teleport#completion#(args, command, cursor) abort
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

  let l:matches = teleport#api#find_matches(l:search)
  let l:matches = type(l:matches) == v:t_list ? l:matches : []
  call map(l:matches, 'v:val.directory')

  return l:matches
endfunc
