func! zcd#driver#load() abort
  let l:driver = s:get_driver_setting()
  return get(s:drivers, l:driver, v:null)
endfunc

let s:drivers = {}
let s:drivers.z = zcd#drivers#rupaz#()
let s:drivers['z.lua'] = zcd#drivers#zlua#()
let s:drivers.zoxide = zcd#drivers#zoxide#()
let s:drivers.test = zcd#drivers#test#()

func! s:get_driver_setting() abort
  let l:driver = zcd#validate#driver(s:drivers)
  let l:path = zcd#validate#path()

  " Invalid settings. Stop here before calling driver methods.
  if index([l:driver, l:path], 'ERROR') >= 0
    return v:null
  endif

  " Null if the user hasn't explicitly set it.
  if l:driver isnot# v:null
    return zcd#validate#support(l:driver, s:drivers)
  endif

  return s:infer_driver()
endfunc

" Return the first compatible driver.
func! s:infer_driver() abort
  for [l:driver_name, l:driver] in items(s:drivers)
    if l:driver.is_supported()
      return l:driver_name
    endif
  endfor

  " We can't find a compatible driver. We have no method of querying.
  return s:admit_failure()
endfunc

func! s:admit_failure() abort
  call zcd#print#error('Error:')
  call zcd#print#(" Can't find a compatible driver.\n")
  call zcd#print#("You'll need to tell z.vim what program to use. See ")
  call zcd#print#function(':help z-config')
  call zcd#print#(' for instructions.')
endfunc
