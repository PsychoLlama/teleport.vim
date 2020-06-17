" --- teleport#path ---
func! teleport#validate#path() abort
  if exists('g:zcd#path')
    return s:report_deprecated_path()
  endif

  let l:path = get(g:, 'teleport#path', v:null)
  if l:path is# v:null
    return v:null
  endif

  if !filereadable(l:path)
    return s:report_invalid_path(l:path)
  endif

  return l:path
endfunc

func! s:report_deprecated_path() abort
  call teleport#print#error('Error:')
  call teleport#print#(' The ')
  call teleport#print#function('zcd#path')
  call teleport#print#(' option is no longer supported. Use ')
  call teleport#print#function('teleport#path')
  call teleport#print#(' instead.')
  call teleport#print#code("\n\n  let teleport#path = '", g:zcd#path, "'\n")

  return 'ERROR'
endfunc

func! s:report_invalid_path(path) abort
  call teleport#print#error('Error:')
  call teleport#print#(' Huh, the ')
  call teleport#print#string('g:teleport#path')
  call teleport#print#(" variable doesn't point to a readable file.\n")
  call teleport#print#("Would you check your vimrc?\n")
  call teleport#print#code("\n  let g:teleport#path = '", g:teleport#path, "'\n")

  return 'ERROR'
endfunc

" --- zcd#driver ---
func! teleport#validate#driver(drivers) abort
  let l:driver = get(g:, 'zcd#driver', v:null)

  if has_key(a:drivers, l:driver)
    return l:driver
  endif

  if l:driver isnot# v:null
    return s:report_invalid_driver(l:driver, a:drivers)
  endif

  return v:null
endfunc

func! s:report_invalid_driver(driver, drivers) abort
  let l:options = keys(a:drivers)
  call filter(l:options, 'v:val isnot# "test"')
  call map(l:options, '"''" . v:val . "''"')

  call teleport#print#error('Error:')
  call teleport#print#(' The ')
  call teleport#print#string('g:zcd#driver')
  call teleport#print#(" variable is invalid.\n\n")
  call teleport#print#code("  let g:zcd#driver = '", a:driver, "'")
  call teleport#print#("\n\nAvailable drivers are: ", join(l:options, ', '))

  return 'ERROR'
endfunc

" Edge case: driver was hard-coded but isn't supported.
func! teleport#validate#support(driver_name, drivers) abort
  let l:driver = a:drivers[a:driver_name]

  if !l:driver.is_supported()
    return s:report_unsupported_driver(a:driver_name)
  endif

  return a:driver_name
endfunc

func! s:report_unsupported_driver(driver_name) abort
  call teleport#print#error('Error:')
  call teleport#print#(" You've hard-coded ")
  call teleport#print#string(a:driver_name)
  call teleport#print#(" as your driver, but teleport.vim can't use it.\n")
  call teleport#print#('See ')
  call teleport#print#function(':help teleport-config')
  call teleport#print#(' for details on configuring a driver.', "\n")
  call teleport#print#code("\n  let zcd#driver = '", a:driver_name, "'\n")

  return v:null
endfunc
