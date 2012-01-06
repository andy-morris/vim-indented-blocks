# indented-block
## Select a block by indentation in Vim

As would be useful in Python and Haskell.

This plugin adds a new text object `i`, for a block defined by consistent
indentation. The motion `ii` only selects the insides of the block, which `ai`
also selects the line above it, since that's generally the delimiter (like a
`def foo():` line in Python, etc.)

There's a global variable `g:indented_blocks_use_footer`, which is a list of
filetypes (the same names as for `set ft=...`). If you're editing a file with
one of these types, then the `ai` motion will also select the line below. This
var is empty at the moment; let me know if there's something good to add to it
by default.

# Features

- Text motions `ii` and `ai`, to select just the inside of the block or also
  the introduction line, respectively
- Usable after an operator (`d`, `y`, etc.), or in visual mode
    + In visual mode, repeating the motion will keep expanding the selection to
      outer levels
- Accepts a count for _n_ enclosing scopes

# Bugs

- Doesn't like one-line blocks. If you try to select one, it'll go for the
  outer one instead.
