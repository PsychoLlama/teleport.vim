" Invoked by :Z ...
func! teleport#(...) abort
  let l:search = join(a:000, ' ')
  let l:match = teleport#api#query(l:search)

  " Error state. Assume it was already echoed.
  if l:match is# 'ERROR' | return | endif

  " No luck. Alert the user.
  if l:match is# v:null
    call teleport#print#error('No matches:')
    call teleport#print#(' ', l:search)
    return v:null
  endif

  " Open the most probable match in the current pane.
  call s:go_to_directory(l:match)
endfunc

func! s:go_to_directory(directory) abort
  let l:target = fnameescape(a:directory)
  let l:auto_lcd = get(g:, 'teleport#set_cwd', v:false)

  execute 'edit ' . l:target

  " Automatically set the window-relative current working directory.
  if l:auto_lcd && getcwd() isnot# simplify(a:directory)
    execute 'lcd ' . l:target
  endif
endfunc
