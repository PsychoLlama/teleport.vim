" https://github.com/rupa/z
let s:rupaz = {}

" Can't infer the path of z.sh.
func! s:ErrorUnresolvablePath() abort
  call zcd#print#error('Error:')
  call zcd#print#(" Unable to locate the z program.\n")
  call zcd#print#("Add an exact path to your vimrc, like this:\n")
  call zcd#print#code("\n  let g:zcd#path = expand('~/path/to/z/z.sh')\n")
  call zcd#print#("\n(reference ")
  call zcd#print#function(':help z-config')
  call zcd#print#(' for more details)')
endfunc

" Figure out where z is located.
func! s:GetPathToZ() abort
  " Prefer the explicitly configured path if it exists.
  if exists('g:zcd#path')
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

  " source z.sh(z.lua); _z(_zlua) -l 'some search term'
  if l:z_path =~# 'z.lua'
    let l:cmd = 'eval "$(lua '. fnameescape(l:z_path).' --init bash)"'
    let l:cmd .=';export _ZL_HYPHEN=1'
    let l:cmd .= '; _zlua -l ' . shellescape(a:search)
  else
    let l:cmd = 'source ' . fnameescape(l:z_path)
    let l:cmd .= '; _z -l ' . shellescape(a:search)
  endif

  return systemlist(l:cmd)
endfunc

func! s:rupaz.is_supported() abort
  " TODO: Wire this up.
endfunc

" TODO: Make this variadic.
func! s:rupaz.query(search) abort
  let l:output = s:GetSearchOutput(a:search)

  if l:output is# v:null
    return v:null
  endif

  return zcd#parse_output#z(l:output)
endfunc

func! zcd#drivers#rupaz#() abort
  return deepcopy(s:rupaz)
endfunc
