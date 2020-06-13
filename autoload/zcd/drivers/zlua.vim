" https://github.com/skywind3000/z.lua
let s:zlua = { 'name': 'z.lua' }

" Execute a shell command to find best folder matches.
func! s:get_search_output(search) abort
  let l:z_path = g:zcd#path

  " env _ZL_HYPHEN=1 /path/to/z.lua -l 'some search term'
  let l:cmd = 'env _ZL_HYPHEN=1 ' . fnameescape(l:z_path)
  let l:cmd .= ' -l ' . shellescape(a:search)

  return systemlist(l:cmd)
endfunc

" This driver is used if the executable path ends in `z.lua`.
func! s:zlua.is_supported() abort
  if !exists('g:zcd#path')
    return v:false
  endif

  if fnamemodify(g:zcd#path, ':t') !=# 'z.lua'
    return v:false
  endif

  return v:true
endfunc

func! s:zlua.query(search) abort
  let l:output = s:get_search_output(a:search)
  if l:output is# v:null
    return v:null
  endif

  return zcd#parse_output#zlua(l:output)
endfunc

func! zcd#drivers#zlua#() abort
  return deepcopy(s:zlua)
endfunc
