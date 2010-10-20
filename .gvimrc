" GUI configurations {{{

" Set guioptions
:set         guioptions+=a " Autoselect
:set         guioptions+=A " Autoselect for the modeless selection.
:set         guioptions-=c " Use console dialogs instead of popup dialogs for simple choices.
:set         guioptions-=e " Add tab pages when indicated with 'showtabline'.
:set         guioptions-=f " Foreground: Don't use fork() to detach the GUI from the shell where it was started.
:set         guioptions-=i " Use a Vim icon.
:set         guioptions+=m " Menu bar is present.
:set         guioptions-=M " The system menu "$VIMRUNTIME/menu.vim" is not sourced.
:set         guioptions+=g " Make menu items that are not active grey.
:set         guioptions-=t " Include tearoff menu items.
:set         guioptions+=T " Include Toolbar.
:set         guioptions+=r " Right-hand scrollbar is always present.
:set         guioptions-=R " Right-hand scrollbar is present when there is a vertically split window.
:set         guioptions-=l " Left-hand scrollbar is always present.
:set         guioptions+=L " Left-hand scrollbar is present when there is a vertically split window.
:set         guioptions-=b " Bottom (horizontal) scrollbar is present.
:set         guioptions-=h " Limit horizontal scrollbar size to the length of the cursor line.

" }}}

