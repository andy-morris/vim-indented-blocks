" Select a block by indentation
" Author:  Andy Morris <andy@adradh.org.uk>
" License: 3-clause BSD

if exists('g:loaded_indented_block')
  finish
endif
let g:loaded_indented_block = 1

" if 'use_footer' is defined for a filetype, then the aI motion also selects
" the line below the indented block, e.g. if a block also has an 'end'. Which
" means it isn't indentation-sensitive, but you might still want to use this I
" suppose.
if !exists('g:indented_blocks_use_footer')
  let g:indented_blocks_use_footer = []
endif

fun <SID>SelectIndentedBlocks(blocks, delims, ...)
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
        if !a:delims
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
  if !a:delims || index(g:indented_blocks_use_footer, &l:filetype) < 0
    let end -= 1
  endif

  if start == line('v') && end == line('.')
    if a:0 > 0
      call <SID>SelectIndentedBlocks(a:blocks + 1, a:delims, a:1, a:2)
    else
      call <SID>SelectIndentedBlocks(a:blocks + 1, a:delims)
    endif
  else
    exe "normal! \<esc>".start."ggV".end."gg"
  endif
endf

comm -count=1 -nargs=* SelectIndentedBlocks
      \ call <SID>SelectIndentedBlocks(<count>, <f-args>)

omap ii <Plug>SelectIndentedBlocksI
map <Plug>SelectIndentedBlocksI
      \ :<c-u>exe "SelectIndentedBlocks" v:count1 0<cr>

omap ai <Plug>SelectIndentedBlocksA
map <Plug>SelectIndentedBlocksA
      \ :<c-u>exe "SelectIndentedBlocks" v:count1 1<cr>

vmap ii <Plug>VSelectIndentedBlocksI
map <Plug>VSelectIndentedBlocksI
      \ :<c-u>exe "SelectIndentedBlocks" v:count1 0 line("'<") line("'>")<cr>

vmap ai <Plug>VSelectIndentedBlocksA
map <Plug>VSelectIndentedBlocksA
      \ :<c-u>exe "SelectIndentedBlocks" v:count1 1 line("'<") line("'>")<cr>
