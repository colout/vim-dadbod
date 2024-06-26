function! s:command(url, output) abort
  let url = db#url#parse(a:url)
  let endpoint_url = []
  if has_key(url, 'user')
    let connection = ['--endpoint-url', url.connection]
  else
    if has_key(url, 'host')
      let profile = url.host
    else
      let profile = 'default'
    endif
  endif
  return ['/Applications/SnowSQL.app/Contents/MacOS/snowsql']
endfunction

function! db#adapter#snowflake#input_extension() abort
  return 'js'
endfunction

function! db#adapter#snowflake#output_extension() abort
  return 'json'
endfunction

function! db#adapter#snowflake#input(url, in) abort
  if filereadable(a:in)
    let lines = readfile(a:in)
    return s:command(a:url, 'json') + split(lines[0])
  endif
  return ['echo', 'no', 'command']
endfunction

function! db#adapter#snowflake#auth_input() abort
  return v:false
endfunction

function! db#adapter#snowflake#tables(url) abort
  let cmd = s:command(a:url, 'text') + ['list-tables']
  let out = db#systemlist(cmd)
  return map(out, 'matchstr(v:val, "\\w*$")')
endfunction

