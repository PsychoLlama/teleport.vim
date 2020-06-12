" https://github.com/skywind3000/z.lua
let s:zlua = {}

func! s:zlua.Exists() abort
  " TODO: Wire this up.
endfunc

func! s:zlua.Query(query) abort
  " TODO
endfunc

func! zcd#drivers#zlua#() abort
  return deepcopy(s:zlua)
endfunc
