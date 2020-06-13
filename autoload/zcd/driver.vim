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

  " Invalid driver.
  if l:driver is# 'ERROR'
    return v:null
  endif

  if l:driver isnot# v:null
    return l:driver
  endif

  " Return the first driver that thinks it's supported.
  for [l:driver_name, l:driver] in items(s:drivers)
    if l:driver.is_supported()
      return l:driver_name
    endif
  endfor

  return v:null
endfunc
