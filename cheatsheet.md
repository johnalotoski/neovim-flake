Leader key is <space> by default

# Builtins

## Global Commands
 - `:h keyword` - Bring up help for keyword
 - `sav file` - Save the current file as another filename
 - `clo` - Close the current pane
 - `ter` - Open a terminal window
 - `ESC` - Return to Normal mode
 - `:w` - Save
 - `:q` - Quit
 - `:q!` - Quit don't save
 - `:wqa` - Save and quit cloing all tabs

## Movement
 - `h(left)`, `j(down)`, `k(up)`, `l(right)` - Move around the screen
 - `gg` - Move to top of buffer
 - `G` - Move to bottom of file
 - `H` - Top of screen
 - `M` - Middle of screen
 - `L` - Bottom of the screen
 - `w` - Jump forward to start of word
 - `e` - Jump forward to end of word
 - `b` - Jump backwards to start of word
 - `%` - Jump forward to matching parenthesis or brace.
 - `0` - Start of line
 - `$` - End of line
 - `^` - First non blank character of line
 - `f(char)` - Move to the next occurrence of character
 - `F(char)` - Move to the previous occurrence of character
 - `;` - Repeat last f or F
 - `,` - Repeat last f or F backwards
 - `{`, `}` - Move around paragraph blocks (works in code too)
 - `ctrl + e` - Move screen down one line without moving cursor
 - `ctrl + y` - Move screen up one line without moving cursor
 - `ctrl + b` - Move back one full screen
 - `ctrl + f` - Move forward one full screen
 - `ctrl + d` - Move forward 1/2 screen
 - `ctrl + u` - Move back one full screen

## Insert Mode
 - `i` - Enter insert mode before cursor
 - `I` - Enter insert mode at the start of the line
 - `a` - Enter insert mode after cursor
 - `A` - Enter insert mode at the end of the line
 - `o` - Append a line below current line
 - `O` - Append a line above current line
 - `ea` - Enter insert mode at the end of the word
 - `ctrl + rX` - Insert the contents of register X

## Editing
 - `r` - Replace single character
 - `J` - Join line below to current one
 - `gwip` - Reflow paragraph
 - `g~` - switch case up to motion
 - `gu` - Lower case up to motion
 - `gU` - Upper case up to motion.
 - `cc` - Replace entire line
 - `C` or `c$` - Replace to end of line.
 - `ciw` - Change entire word
 - `cw` - Replace to end of word
 - `u` - Undo
 - `U` - Redo
 - `.` - Repeat last command

## Text Marking
 - `v` - Visual mode
 - `V` - Start linewise visual mode (select lines)
 - `o` - Move to other end of marked area.
 - `Ctrl + v` - Visual Block mode
 - `Ctrl + O` - Other corner of block
 - `aw` - Mark a word
 - `ab` - Mark block with ()
 - `aB` - Mark block with {}
 - `ib` - Mark inner block with ()
 - `iB` - Mark inner block with {}
 - `at` - Mark tags with <>

## Visual Commands
 - `>` - Shift text right
 - `<` - Shift text left
 - `y` - Yank marked text
 - `d` - Delete marked text
 - `~` - Switch case
 - `u` - Change case to lowercase
 - `U` - Change case to uppercase

## Registers
 - `:reg` - Show register content
 - `"xy` - Yank into register x
 - `"xp` - Paste contents of register x
 - `"+y` - Yank into system clipboard
 - `"+p` - Paste from system clipboard

## Marks and Positions
 - `:marks` - Lists all marks
 - `ma` - Set position of mark a
 - \`a - Jump back to a
 - \`. - Go to position when last editing the file
 - \`\` - Go to position before last jump
 - `:ju` - List of jumps
 - `ctrl + i` - Newer position in jump list
 - `ctrl + o` - Older position in jump list
 - `:changes` - List changes
 - `g,` - Go to newer change
 - `g;` - Go to older change

## Macros
 - `qa` - Record macro a
 - `q` - Stop recording macro
 - `@a` - Run macro a
 - `@@` - rerun last macro

## Cut and Paste
 - `yy` - Yank line
 - `yw` - Yank word
 - `y$` - Yank to end of line
 - `p` - Paste clipboard after cursor
 - `P` - Paste clipboard before cursor
 - `dd` - Delete line
 - `dw` - Delete word (from current cursor to next start of word)
 - `d$` - Delete till end of line
 - `x` - Delete character

## Indent text
 - `<<` - Move line left
 - `>>` - Move line right
 - `>%` - Indent block (when on brace or paren)
 - `=%` - Re-indent block

## Searching and patterns
 - `/pattern` - Search for pattern
 - `?pattern` - Search backwards for pattern
 - `n` - Repeat search in same direction
 - `N` - Repeat search in opposite direction
 - `:%s/old/new/g` - Replace all old with new throughout the file
 - `:%s/old/new/gc` - Replace all old with new throughout the file with confirmations
 - `:noh` - Remove highlighting of search matches
 - `:vimgrep /pattern/ **/*` - Search for pattern in all files
 - `:cn` - Next match
 - `:cp` - Prev match
 - `:cope` - List of all matches found
 - `:ccl` - Close list of all matches

## Tabs
 - `:tabnew [file]` - Open file in new tab
 - `Ctrl + wT` - Move current split window into its own tab
 - `gt` - Go to next tab
 - `gT` - Go to prev tab
 - `#gt` - Go to tab number
 - `:tabc` - Close current tab
 - `:tabo` - Close other tabs but this one.

## Buffers
 - `:e file` - Edit file in a new buffer
 - `:bn` - Next buffer
 - `:bp` - Prev buffer
 - `:bd` - Close buffer
 - `:ls` - List open buffers

## Splits
 - `:sp file` - Open file in new buffer and split
 - `:vs file` - Open file in new buffer and split (vertical)
 - `:tab ba` - Open all buffers as tabs
 - `ctrl + ws` - Split window
 - `ctrl + wv` - Split window vertical
 - `ctrl + ww` - Switch window
 - `ctrl + wq` - Quit window
 - `ctrl + wx` - Exchange window with next one
 - `ctrl + w=` - Make all windows equal height and width
 - `ctrl + wh` - Move to left window
 - `ctrl + wl` - Move to right window
 - `ctrl + wj` - Move to below window
 - `ctrl + wk` - Move to above window


# Custom Mappings

## Telescope
 - `leader + fb` - Buffers
 - `leader + ff` - Find file
 - `leader + fg` - Live grep
 - `leader + fh` - Help tags

## File tree
 - `leader + n` - Toggle file tree
 - `a` - Add new file (or folder if you leave a / at end)
 - `r` - Rename file
 - `d` - Delete file or folder
 - `y` - Copy file name to system clipboard
 - `Y` - Copy relative path to system clipboard
 - `gy` - Copy absolute path to system clipboard
 - `x` - Cut file
 - `p` - Paste file from clipboard
 - `ctrl + v` - Open in vert split
 - `ctrl + x` - Open in horizontal split
 - `tab` - Open file but stay in tree (preview)
 - `R` - Refresh tree
 - `I` - Toggle hidden folders visibility
 - `H` - Toggle dot files visibility

## LSP
 - `F2` - Rename
 - `Leader + R` - Rename
 - `Leader + r` - References
 - `Leader + D` - Go to definition
 - `Leader + I` - Go to implementation
 - `Leader + e` - Show document diagnostics
 - `Leader + E` - Show workspace diagnostics
 - `Leader + f` - Format buffer
 - `Leader + k` - Signature help
 - `Leader + K` - Hover text
 - `Leader + a` - Do code action

## Debug
 - `F5` - Run
 - `F10` - Step over
 - `F11` - Step into
 - `F12` - Step out
 - `<leader> + b` - Set break point
 - `F9` - Open debug repl
 - `<leader> + d` - All dap commands
 - `<leader> + B` - List break points
 - `<leader> + dv` - List variables
 - `<leader> + df` - List frames

## Test runner
 - `<leader> + t` - Run whole test suite
 - `<leader> + tn`

## Terminal Windows
 - `<leader>~` - Open new floating terminal
 - `<leader>~j` - Next floating terminal
 - `<leader>~k` - Prev floating terminal
 - `<escape>` - Close terminal

## Git
 - `<leader>g` - Open magit fullscreen
 - `enter` - Expand hunks
 - `R` - Refresh magit buffer
 - `q` - Quit magit buffer
 - `s` - Stage or unstag hunk
 - `F` - Stage or unstag the whole file
 - `DDD` - Discard changes to hunk
 - `L` - Stage the line under cursor
 - `E` - Edit file that is selected
 - `CA` - Set commit mode to ammend
 - `CU` - Go back to stage mode
 - `I` - Add file under cursor
 - `CC` - Commit changes or move to commit mode
