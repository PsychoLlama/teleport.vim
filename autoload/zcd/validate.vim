" --- zcd#path ---
func! zcd#validate#path() abort
  let l:path = get(g:, 'zcd#path', v:null)
  if l:path is# v:null
    return v:null
  endif

  if !filereadable(l:path)
    return s:report_invalid_path(l:path)
  endif

  return l:path
endfunc

func! s:report_invalid_path(path) abort
  call zcd#print#error('Error:')
  call zcd#print#(' Huh, the ')
  call zcd#print#string('g:zcd#path')
  call zcd#print#(" variable doesn't point to a readable file.\n")
  call zcd#print#("Would you check your vimrc?\n")
  call zcd#print#code("\n  let g:zcd#path = '", g:zcd#path, "'\n")

  return 'ERROR'
endfunc

" --- zcd#driver ---
func! zcd#validate#driver(drivers) abort
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

  call zcd#print#error('Error:')
  call zcd#print#(' The ')
  call zcd#print#string('g:zcd#driver')
  call zcd#print#(" variable is invalid.\n\n")
  call zcd#print#code("  let g:zcd#driver = '", a:driver, "'")
  call zcd#print#("\n\nAvailable drivers are: ", join(l:options, ', '))

  return 'ERROR'
endfunc

" Edge case: driver was hard-coded but isn't supported.
func! zcd#validate#support(driver_name, drivers) abort
  let l:driver = a:drivers[a:driver_name]

  if !l:driver.is_supported()
    return s:report_unsupported_driver(a:driver_name)
  endif

  return a:driver_name
endfunc

func! s:report_unsupported_driver(driver_name) abort
  call zcd#print#error('Error:')
  call zcd#print#(" You've hard-coded ")
  call zcd#print#string(a:driver_name)
  call zcd#print#(" as your driver, but z.vim can't use it.\n")
  call zcd#print#('See ')
  call zcd#print#function(':help z-config')
  call zcd#print#(' for details on configuring a driver.', "\n")
  call zcd#print#code("\n  let zcd#driver = '", a:driver_name, "'\n")

  return v:null
endfunc
