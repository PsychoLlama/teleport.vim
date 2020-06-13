" https://github.com/skywind3000/z.lua
let s:zlua = {}

" TODO: Move this out of drivers.
func! s:GetPathToZ() abort
  return get(g:, 'zcd#path', v:null)
endfunc

" Execute a shell command to find best folder matches.
func! s:GetSearchOutput(search) abort
  let l:z_path = s:GetPathToZ()
  if l:z_path is# v:null
    return v:null
  endif

  " env _ZL_HYPHEN=1 /path/to/z.lua -l 'some search term'
  let l:cmd = 'env _ZL_HYPHEN=1 ' . fnameescape(l:z_path)
  let l:cmd .= ' -l ' . shellescape(a:search)

  return systemlist(l:cmd)
endfunc

" TODO: Make this shared.
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

" This driver is used if the executable path ends in `z.lua`.
func! s:zlua.is_supported() abort
  if !has_key(g:, 'zcd#path')
    return v:false
  endif

  if fnamemodify(g:zcd#path, ':t') !=# 'z.lua'
    return v:false
  endif

  return v:true
endfunc

func! s:zlua.query(search) abort
  let l:output = s:GetSearchOutput(a:search)
  return s:ParseOutput(l:output)
endfunc

func! zcd#drivers#zlua#() abort
  return deepcopy(s:zlua)
endfunc
