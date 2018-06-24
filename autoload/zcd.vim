" Uses `z` to search for directories by 'frecency'.
" Output is:
" [frecency]     /absolute/folder/path/

" Invalid g:zcd#path config.
func! s:ErrorInvalidPathConfig() abort
  echohl Error
  echon 'Error(z.vim): '
  echohl None
  echon 'Huh, the '
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
  echon 'unable to locate the z.sh file.' "\n"
  echon 'Add an exact path to your vimrc, like this:' "\n"
  echohl Comment
  echon "\n" '  let g:zcd#path = expand(''~/path/to/z/z.sh'')' "\n"
  echohl None
endfunc

" Figure out where z.sh is located.
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

" Execute a shell command to find best folder matches.
func! s:GetSearchOutput(search) abort
  let l:z_path = s:GetPathToZ()
  if l:z_path is# v:null
    return v:null
  endif

  " source z.sh; _z -l 'some search term'
  let l:cmd = 'source ' . fnameescape(l:z_path)
  let l:cmd .= '; _z -l ' . shellescape(a:search)

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

" Parse z.sh output into a list of possible matches.
" Ordered descending by match probability (assumes z.sh output order).
func! zcd#FindMatches(search) abort
  let l:output = s:GetSearchOutput(a:search)
  return s:ParseOutput(l:output)
endfunc

" Invoked by :Z ...
func! zcd#(...) abort
  let l:search = join(a:000, ' ')
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
  execute 'edit ' . fnameescape(l:matches[0].directory)
endfunc
