" Select a block by indentation
" Author:  Andy Morris <andy@adradh.org.uk>
" License: 3-clause BSD

if exists('g:loaded_indented_block')
  finish
endif
let g:loaded_indented_block = 1

if !exists('g:indented_blocks_ignore_header')
  let g:indented_blocks_ignore_header = []
endif
if !exists('g:indented_blocks_use_footer')
  let g:indented_blocks_use_footer = []
endif

fun <SID>SelectIndentedBlocks(blocks, ...)
  let blocks = a:blocks > 0? a:blocks : 1
  let start  = a:0 > 0? a:1 : line('v')
  let end    = a:0 > 0? a:2 : line('.')
  let indent = indent(start)

  if start != end
    let blocks += 1
  endif

  while 1
    let start -= 1
    if start < 1
      let start = 1
      break
    endif

    if getline(start) == ''
      continue
    endif

    let cur_indent = indent(start)
    if cur_indent < indent
      let blocks -= 1
      if blocks <= 0
        if index(g:indented_blocks_ignore_header, &l:filetype) >= 0
          let start += 1
        endif
        break
      endif
      let indent = cur_indent
    endif
  endw

  while indent(end) >= indent || getline(end) == ''
    let end += 1

    if end > line('$')
      break
    endif
  endw
  if index(g:indented_blocks_use_footer, &l:filetype) < 0
    let end -= 1
  endif

  if start == line('v') && end == line('.')
    call <SID>SelectIndentedBlocks(a:blocks + 1)
  else
    exe "normal! \<esc>".start."ggV".end."gg"
  endif
endf

comm -count=1 -nargs=* SelectIndentedBlocks
      \ call <SID>SelectIndentedBlocks(<count>, <f-args>)
map <Plug>SelectIndentedBlocks :<c-u>exe "SelectIndentedBlocks" v:count1<cr>
map <Plug>VSelectIndentedBlocks
      \ :<c-u>exe "SelectIndentedBlocks" v:count1 line("'<") line("'>")<cr>
omap ai <Plug>SelectIndentedBlocks
vmap ai <Plug>VSelectIndentedBlocks
