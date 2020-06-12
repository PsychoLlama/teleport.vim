" Uses `z` to search for directories by 'frecency'.
" Output is:
" [frecency]     /absolute/folder/path/

func! s:GoToDirectory(directory) abort
  execute 'edit ' . fnameescape(a:directory)
endfunc

" The user entered a single expandable variable, like '~'. Just go there.
func! s:GetObviousDestination(input, expanded) abort
  " See if `expand(...)` thinks the input is special.
  if len(a:input) is# 1 && a:input[0] isnot# a:expanded[0]
    return a:expanded[0]
  endif

  return v:null
endfunc

" Expand special symbols like '~', `%:h`, or `$HOME`.
func! s:ExpandSymbols(input) abort
  return map(copy(a:input), 'expand(v:val)')
endfunc

" Parse z.sh output into a list of possible matches.
" Ordered descending by match probability (assumes z.sh output order).
func! zcd#FindMatches(search) abort
  let l:driver = zcd#driver#load()
  if l:driver is# v:null
    return v:null
  endif

  return l:driver.Query(a:search)
endfunc

" Invoked by :Z ...
func! zcd#(...) abort
  let l:expanded = s:ExpandSymbols(a:000)
  let l:obvious_destination = s:GetObviousDestination(a:000, l:expanded)

  if l:obvious_destination isnot# v:null
    return s:GoToDirectory(l:obvious_destination)
  endif

  let l:search = join(l:expanded, ' ')
  let l:matches = zcd#FindMatches(l:search)

  " Error state. Assume it was already echoed.
  if l:matches is# v:null
    return v:null
  endif

  " No luck. Alert the user.
  if len(l:matches) is 0
    call zcd#print#error('No matches:')
    call zcd#print#(' ', l:search)
    return
  endif

  " Open the most probable match in the current pane.
  call s:GoToDirectory(l:matches[0].directory)
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

  let l:matches = zcd#FindMatches(l:search)
  let l:matches = type(l:matches) == v:t_list ? l:matches : []
  call map(l:matches, 'v:val.directory')

  return l:matches
endfunc
