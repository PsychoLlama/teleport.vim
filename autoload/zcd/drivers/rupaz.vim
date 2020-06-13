" https://github.com/rupa/z
let s:rupaz = { 'name': 'rupa/z' }

" Figure out where z is located.
func! s:resolve_executable() abort
  " Prefer the explicitly configured path if it exists.
  if exists('g:zcd#path')
    return g:zcd#path
  endif

  " Fall back to the oh-my-zsh framework.
  let l:path = $ZSH . '/plugins/z/z.sh'
  if strlen($ZSH) && filereadable(l:path)
    return l:path
  endif

  return v:null
endfunc

" Execute a shell command to find best folder matches.
func! s:get_search_output(search) abort
  let l:z_path = s:resolve_executable()
  if l:z_path is# v:null
    return v:null
  endif

  " source z.sh; _z -l 'some search term'
  let l:cmd = 'source ' . fnameescape(l:z_path)
  let l:cmd .= '; _z -l ' . shellescape(a:search)

  return systemlist(l:cmd)
endfunc

" Find the executable path. If it ends in z.sh OR the driver is explicitly
" enabled, consider it supported.
func! s:rupaz.is_supported() abort
  let l:zcd_path = s:resolve_executable()

  if l:zcd_path is# v:null
    return v:false
  endif

  let l:supported_executable = fnamemodify(l:zcd_path, ':t') is# 'z.sh'
  let l:explicitly_enabled = get(g:, 'zcd#driver', v:null) is# 'z'
  if l:supported_executable || l:explicitly_enabled
    return v:true
  endif

  return v:false
endfunc

" TODO: Make this variadic.
func! s:rupaz.query(search) abort
  let l:output = s:get_search_output(a:search)

  if l:output is# v:null
    return v:null
  endif

  return zcd#parse_output#z(l:output)
endfunc

func! zcd#drivers#rupaz#() abort
  return deepcopy(s:rupaz)
endfunc
