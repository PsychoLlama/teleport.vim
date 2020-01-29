" Uses `z` to search for directories by 'frecency'.
" Output is:
" [frecency]     /absolute/folder/path/

" Invalid g:zcd#path config.
func! s:ErrorInvalidPathConfig() abort
  echohl Error
  echon 'Error(z.vim):'
  echohl None
  echon ' Huh, the '
  echohl String
  echon 'g:zcd#path'
  echohl None
  echon " variable doesn't point to a readable file." "\n"
  echon 'Would you investigate? '
  echon "(it's probably in your vimrc)" "\n"
  echohl Comment
  echon "\n" '  let g:zcd#path = ''' . g:zcd#path . "'" "\n"
  echohl None
endfunc

" Can't infer the path of z.sh.
func! s:ErrorUnresolvablePath() abort
  echohl Error
  echon 'Error(z.vim): '
  echohl None
  echon 'unable to locate the z file.' "\n"
  echon 'Add an exact path to your vimrc, like this:' "\n"
  echohl Comment
  echon "\n" '  let g:zcd#path = expand(''~/path/to/(z/z.sh|z.lua/z.lua)'')' "\n"
  echohl None
endfunc

" Figure out where z is located.
func! s:GetPathToZ() abort
  " Prefer the explicitly configured path if it exists.
  if exists('g:zcd#path')
    " Nope, invalid path.
    if !filereadable(g:zcd#path)
      call s:ErrorInvalidPathConfig()
      return v:null
    endif

    return g:zcd#path
  endif

  " Fall back to the oh-my-zsh framework.
  let l:path = $ZSH . '/plugins/z/z.sh'
  if strlen($ZSH) && filereadable(l:path)
    return l:path
  endif

  call s:ErrorUnresolvablePath()
  return v:null
endfunc

" Expand special symbols like '~', `%:h`, or `$HOME`.
func! s:ExpandSymbols(input) abort
  return map(copy(a:input), 'expand(v:val)')
endfunc

" The user entered a single expandable variable, like '~'. Just go there.
func! s:GetObviousDestination(input, expanded) abort
  " See if `expand(...)` thinks the input is special.
  if len(a:input) is# 1 && a:input[0] isnot# a:expanded[0]
    return a:expanded[0]
  endif

  return v:null
endfunc

" Execute a shell command to find best folder matches.
func! s:GetSearchOutput(search) abort
  let l:z_path = s:GetPathToZ()
  if l:z_path is# v:null
    return v:null
  endif

  " source z.sh(z.lua); _z(_zlua) -l 'some search term'
  if l:z_path =~ 'z.lua'
    let l:cmd = 'eval "$(lua '. fnameescape(l:z_path).' --init bash)"'
    let l:cmd .=';export _ZL_HYPHEN=1'
    let l:cmd .= '; _zlua -l ' . shellescape(a:search)
  else
    let l:cmd = 'source ' . fnameescape(l:z_path)
    let l:cmd .= '; _z -l ' . shellescape(a:search)
  endif

  return systemlist(l:cmd)
endfunc

func! s:ParseOutput(output) abort
  " z.sh probably couldn't be located.
  if a:output is# v:null
    return v:null
  endif

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

func! s:GoToDirectory(directory) abort
  execute 'edit ' . fnameescape(a:directory)
endfunc

" Parse z.sh output into a list of possible matches.
" Ordered descending by match probability (assumes z.sh output order).
func! zcd#FindMatches(search) abort
  let l:output = s:GetSearchOutput(a:search)
  return s:ParseOutput(l:output)
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
    echohl Error
    echon 'No matches: '
    echohl None
    echon l:search
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
