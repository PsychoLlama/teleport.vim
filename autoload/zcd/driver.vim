func! zcd#driver#load() abort
  let l:driver = s:get_driver_setting()
  return get(s:drivers, l:driver, v:null)
endfunc

let s:drivers = {}
let s:drivers.z = zcd#drivers#rupaz#()
let s:drivers.zoxide = zcd#drivers#zoxide#()
let s:drivers.test = zcd#drivers#test#()

func! s:get_driver_setting() abort
  let l:driver = get(g:, 'zcd#driver', v:null)

  if l:driver isnot# v:null && !has_key(s:drivers, l:driver)
    return s:yell_at_someone(l:driver)
  endif

  if l:driver isnot# v:null
    return l:driver
  endif

  return s:infer_driver()
endfunc

func! s:yell_at_someone(driver) abort
  let l:options = keys(s:drivers)
  call filter(l:options, 'v:val isnot# "test"')
  call map(l:options, '"''" . v:val . "''"')

  call zcd#print#error('Error:')
  call zcd#print#(' the ')
  call zcd#print#string('g:zcd#driver')
  call zcd#print#(" variable is invalid.\n\n")
  call zcd#print#code("  let g:zcd#driver = '", a:driver, "'")
  call zcd#print#("\n\nAvailable drivers are: ", join(l:options, ', '))

  return v:null
endfunc

func! s:infer_driver() abort
  for [l:driver_name, l:driver] in items(s:drivers)
    if l:driver.Exists()
      return l:driver_name
    endif
  endfor

  return v:null
endfunc
