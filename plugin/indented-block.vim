" Select a block by indentation
" Author:  Andy Morris <andy@adradh.org.uk>
" License: 3-clause BSD

if exists('g:loaded_indented_block')
  finish
endif
let g:loaded_indented_block = 1

fun <SID>SelectIndentedBlocks(blocks)
  let blocks = a:blocks > 0? a:blocks : 1
  let start  = line('.')
  let end    = line('.')
  let indent = indent(start)

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
      if blocks == 0
        let start += 1
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
  let end -= 1

  exe "normal! \<esc>".start."ggV".end."gg"
endf

comm -count=1 SelectIndentedBlocks call <SID>SelectIndentedBlocks(<count>)
map <Plug>SelectIndentedBlocks :<c-u>exe "SelectIndentedBlocks" v:count1<cr>
omap ai <Plug>SelectIndentedBlocks
