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
  call zcd#print#(' the ')
  call zcd#print#string('g:zcd#driver')
  call zcd#print#(" variable is invalid.\n\n")
  call zcd#print#code("  let g:zcd#driver = '", a:driver, "'")
  call zcd#print#("\n\nAvailable drivers are: ", join(l:options, ', '))

  return 'ERROR'
endfunc
