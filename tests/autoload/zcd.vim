  func! zcd#FindMatches(search)
    return [{ 'directory': a:search }, { 'directory': '/dir/second' }]
  endfunc
