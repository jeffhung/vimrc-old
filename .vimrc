" Use vim settings, rather then vi settings (much better!)
" This must be first, because it changes other options as a side effect.
:set nocompatible

" Use pathogen to easily modify the runtime path to include all plugins under
" the ~/.vim/bundle directory
:filetype off                    " force reloading *after* pathogen loaded
:call pathogen#helptags()
:call pathogen#runtime_append_all_bundles()
:filetype plugin indent on       " enable detection, plugins and indenting in one step

" Quickly edit/reload the vimrc file
:nmap <silent> <leader>ev :e $MYVIMRC<CR>
:if has("autocmd")
	:augroup myvimrchooks
		:au!
		:autocmd bufwritepost .vimrc source $HOME/.vimrc
	:augroup END
:endif

" Determine ctags programs {{{
" - The complex exctags arguments are already specified in CTAGS environment
"   variable.
" jeffhung.20080319:
" - No, cmd.exe is used for invoking ctags command, so we will not get CTAGS
"   from ~/.cshrc.
:let ctags_opts = '--c-kinds=+lpx --c++-kinds=+lpx --fields=+ailmS --extra=+fq --exclude=.svn --exclude=CVS'
:if (executable('exctags'))
	:let ctags_cmd = 'exctags'
:elseif (executable('/usr/local/bin/ctags')) " *BSD, HomeBrew
	:let ctags_cmd = '/usr/local/bin/ctags'
:elseif (executable('/opt/local/bin/ctags')) " MacPorts
	:let ctags_cmd = '/opt/local/bin/ctags'
:elseif (executable('ctags'))
	" - We may get trouble if ctags is not exuberant-ctags.
	:let ctags_cmd = 'ctags'
:endif
" }}}

" Editing behaviour {{{
:set showmode                    " always show what mode we're currently editing in
:set wrap                        " wrap lines
:set wrapscan                    " Searches wrap around the end of the file.
"set wrapmargin=0                " When textwidth is non-zero, wrapmargin is not used.
:set ruler                       " Show the line and column number of the cursor position, separated by a comma.
:set tabstop=4                   " a tab is four spaces
:set softtabstop=4               " when hitting <BS>, pretend like a tab is removed, even if spaces
"set expandtab                   " expand tabs by default (overloadable per file type later)
"set smarttab                    " insert tabs on the start of a line according to
                                 "    shiftwidth, not tabstop
:set shiftwidth=4                " number of spaces to use for autoindenting
:set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
:set backspace=indent,eol,start  " allow backspacing over everything in insert mode
"set autoindent                  " always set autoindenting on
:set copyindent                  " copy the previous indentation on autoindenting
:set number                      " always show line numbers
:set showmatch                   " set show matching parenthesis
"set ignorecase                  " ignore case when searching
:set smartcase                   " ignore case if search pattern is all lowercase,
                                 "    case-sensitive otherwise
:set scrolloff=4                 " keep 4 lines off the edges of the screen when scrolling
"set virtualedit=all             " allow the cursor to go in to "invalid" places
:set hlsearch                    " highlight search terms
:set noincsearch                 " don't show search matches as you type
"set gdefault                    " search/replace "globally" (on a line) by default
set listchars=tab:▸\ ,trail:·,extends:#,nbsp:·,extends:»,precedes:«
" jeffhung.20060525: Show special characters, like how Editplus do.
":if !has("win32") && !exists("$OS_DARWIN")
"	:set	listchars=tab:»\ ,trail:.,extends:>,precedes:<
":else
"	:set	listchars=tab:`\ ,trail:.,extends:>,precedes:<
":endif

:set list                        " show invisible characters by default,
                                 "    but it is enabled for some file types (see later)
:set pastetoggle=<F2>            " when in insert mode, press <F2> to go to
                                 "    paste mode, where you can paste mass data
                                 "    that won't be autoindented
" jeffhung.20101101: Mouse is anonying in terminal.
"set mouse=a                     " enable using the mouse if terminal emulator
                                 "    supports it (xterm does)
"set fileformats="unix,dos,mac"

" jeffhung.20080824: Only wrap for comments, not text (codes).
:set formatoptions=croq
:set formatoptions+=1            " When wrapping paragraphs, don't end lines
                                 "    with 1-letter words (looks stupid)

"  Write the contents of the file, if it has been modified, on each
" :next, :rewind, :last, :first, :previous, :stop, :suspend, :tag, :!,
" :make, CTRL-] and CTRL-^ command; and when a :buffer, CTRL-O, CTRL-I,
" '{A-Z0-9}, or `{A-Z0-9} command takes one to another file.
" Note that for some commands the 'autowrite' option is not used, see
" 'autowriteall' for that.
:set autowrite

" Thanks to Steve Losh for this liberating tip
" See http://stevelosh.com/blog/2010/09/coming-home-to-vim
:nnoremap / /\v
:vnoremap / /\v

" Speed up scrolling of the viewport slightly
:nnoremap <C-e> 2<C-e>
:nnoremap <C-y> 2<C-y>
" }}}

" Diff options {{{
" Set diff options to:
" - Show filler lines, to keep the text synchronized with a window that has
"   inserted lines at the same position
" - Ignore changes in amount of white space.
:set	diffopt=filler,iwhite
" }}}

" Folding rules {{{
:set foldenable                  " enable folding
:set foldcolumn=2                " add a fold column
:set foldmethod=marker           " detect triple-{ style fold markers
:set foldlevelstart=0            " start out with everything folded
:set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
                                " which commands trigger auto-unfold
:function! MyFoldText()
	:let line = getline(v:foldstart)

	:let nucolwidth = &fdc + &number * &numberwidth
	:let windowwidth = winwidth(0) - nucolwidth - 3
	:let foldedlinecount = v:foldend - v:foldstart

	" expand tabs into spaces
	:let onetab = strpart('          ', 0, &tabstop)
	:let line = substitute(line, '\t', onetab, 'g')

	:let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
	:let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 4
	:return line . ' …' . repeat(" ",fillcharcount) . foldedlinecount . ' '
:endfunction
:set foldtext=MyFoldText()
" }}}

" Editor layout {{{
:set termencoding=utf-8
:set encoding=utf-8
:set lazyredraw                  " don't update the display while executing macros
:set laststatus=2                " tell VIM to always put a status line in, even
                                 "    if there is only one window
"set cmdheight=2                 " use a status bar that is 2 rows high
:set cmdheight=1
"set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{fugitive#statusline()}%{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P
:set statusline=%<%f\ %m%=\ %h%r\ %-19([%p%%]\ %3l,%02c%03V%)%y

" Use better color to show foreground window.
:highlight statusline ctermfg=blue ctermbg=white

" }}}

" GUI settings {{{

:if has("gui_running")
	" Set desired fontset for various systems:
	"   guifontwide:
	"     * MingLiU
	"   guifont:
	"     * Bitstream Vera Sans Mono
	"     * Consolas
	"     * Courier New
	"     * Monospace
	:if has("gui_gtk2")
		:set         guifont=monospace\ 10
		" jeffhung.20070301:
		" - We do not need to set guifontwide manually since we have Pango/Xft.  Xft
		"   will find appropriate wide font for us.
		":set         guifontwide=MingLiU\ 12
	:elseif has("gui_mac") || has("gui_macvim")
		:set         guifont=Monaco:h13
	:elseif has("gui_win32")
		:set         guifont=Consolas:h11:cANSI
"		:set         guifont=Bitstream_Vera_Sans_Mono:h10:cANSI
"		:set         guifont=Monaco:h8:cANSI
" jeffhung.20070725:
" - Consolas is not pretty enough compare to Bitstream_Vera_Sans_Mono in small
"   fonts.
" - But h14 is too big.
"		:set         guifont=Consolas:h14:cANSI
		" jeffhung.20070301:
		" - We do not need to set guifontwide manually in Windows, too.
		":set         guifontwide=MingLiU\ 12

" jeffhung.20070725: Not working.
"		" @sa http://c9s.blogspot.com/2007/07/gvim-language.html
"		"     Set english locale and window size:
"		"       lang en
"		"       language mes en
"		"       set langmenu=en_US.UTF-8
"		"       winsize 720 520
"		" jeffhung.20070725:
"		" - We should not set language (messages) or we may not be able to
"		"   write Chinese.  Therefore, here I only changed the langmenu
"		"   setting.
"		:set langmenu=en_US.UTF-8
		" @sa http://blog.dragon2.net/2008/03/01/516.php
"		:source $VIMRUNTIME/delmenu.vim
"		:language messages zh_TW.UTF-8
"		:source $VIMRUNTIME/menu.vim
	:elseif has("x11")
		:set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
	:endif

"	:set guifont=Inconsolata:h14
	:"colorscheme baycomb
	:"colorscheme mustang
"	:colorscheme molokai

	" Set guioptions
	:set guioptions+=a     " Autoselect
	:set guioptions+=A     " Autoselect for the modeless selection.
	:set guioptions-=c     " Use console dialogs instead of popup dialogs for simple choices.
	:set guioptions-=e     " Add tab pages when indicated with 'showtabline'.
	:set guioptions-=f     " Foreground: Don't use fork() to detach the GUI from the shell where it was started.
	:set guioptions-=i     " Use a Vim icon.
	:set guioptions+=m     " Menu bar is present.
	:set guioptions-=M     " The system menu "$VIMRUNTIME/menu.vim" is not sourced.
	:set guioptions+=g     " Make menu items that are not active grey.
	:set guioptions-=t     " Include tearoff menu items.
	:set guioptions+=T     " Include Toolbar.
	:set guioptions+=r     " Right-hand scrollbar is always present.
	:set guioptions-=R     " Right-hand scrollbar is present when there is a vertically split window.
	:set guioptions-=l     " Left-hand scrollbar is always present.
	:set guioptions+=L     " Left-hand scrollbar is present when there is a vertically split window.
	:set guioptions-=b     " Bottom (horizontal) scrollbar is present.
	:set guioptions-=h     " Limit horizontal scrollbar size to the length of the cursor line.

"	" Screen recording mode
"	:function! ScreenRecordMode()
"		:set columns=86
"		:set guifont=Droid\ Sans\ Mono:h14
"		:set cmdheight=1
"		:colorscheme molokai_deep
"	:endfunction
"	:command! -bang -nargs=0 ScreenRecordMode call ScreenRecordMode()

	:if has("gui_win32")
		:set lines=41
		:set columns=140
	:elseif has("gui_mac") || has("gui_macvim")
		:set lines=43
		:set columns=132
	:else
		:set lines=41
		:set columns=125
	:endif
endif

" }}}

" Vim behaviour {{{
"set hidden                      " hide buffers instead of closing them this
                                 "    means that the current buffer can be put
                                 "    to background without being written; and
                                 "    that marks and undo history are preserved
"set switchbuf=useopen           " reveal already opened files from the
                                 " quickfix window instead of opening new
                                 " buffers
:set history=1000                " remember more commands and search history
:set undolevels=1000             " use many muchos levels of undo
:if v:version >= 730
	:set undofile                " keep a persistent backup file
	:set undodir=~/.vim/.undo,~/tmp,/tmp
:endif
:set nobackup                    " do not keep backup files, it's 70's style cluttering
:set nowritebackup               " do not backup before overwriting a file
:set noswapfile                  " do not write annoying intermediate swap files,
                                 "    who did ever restore from swap files anyway?
:set directory=~/.vim/.tmp,~/tmp,/tmp
                                 " store swap files in one of these directories
                                 "    (in case swapfile is ever turned on)
:set viminfo='20,\"80            " read/write a .viminfo file, don't store more
                                 "    than 80 lines of registers
:set title                       " change the terminal's title
"set visualbell                  " don't beep
:set novisualbell
:set noerrorbells                " don't beep
:set showcmd                     " show (partial) command in the last line of the screen
                                 "    this also shows visual selection info
" SECURITY NOTE: The VIM software has had several remote vulnerabilities
" discovered within VIM's modeline support.  It allowed remote attackers to
" execute arbitrary code as the user running VIM.  All known problems
" have been fixed, but the FreeBSD Security Team advises that VIM users
" use 'set nomodeline' in ~/.vimrc to avoid the possibility of trojaned
" text files.
:set nomodeline                  " disable mode lines (security measure)
"set ttyfast                     " always use a fast terminal

" Tune wildmenu support {{{
:set wildmenu                    " make tab completion for files/buffers act like bash
"set wildmode=list:full          " show a list when pressing tab and complete
"                                "    first full match
:set wildmode=list:longest       " Set wildmode like how I did in tcsh.
"set wildignore=*.swp,*.bak,*.pyc,*.class
:set wildignore+=*.swp           " List of file patterns to ignore when listing with
                                 "    wildmenu.
:set wildignore+=*.bak
:set wildignore+=*.o
:set wildignore+=*.lo
:set wildignore+=*.a
:set wildignore+=*.so
:set wildignore+=*.obj
:set wildignore+=*.exe
:set wildignore+=*.lib
:set wildignore+=*.ncb
:set wildignore+=*.opt
:set wildignore+=*.plg
:set wildignore+=*.vcproj.*.*.user
:set wildignore+=*.class
:set wildignore+=*.pyc
" }}}

" cursorline {{{
:set cursorline                  " underline the current line, for quick orientation
if version >= 700
	" Set tab-line colors
	:highlight TabLine     term=bold,underline cterm=bold,underline ctermfg=0 ctermbg=7
	:highlight TabLineSel  term=bold cterm=bold ctermfg=3 ctermbg=0
	:highlight TabLineFill term=underline cterm=underline ctermfg=0 ctermbg=7
endif
" }}}

" Use wcgrep.sh as the grep program if it exist. {{{
if (executable('wcgrep.sh'))
	if has('win32')
		:set grepprg=wcgrep.bat
	else
		:set grepprg=wcgrep.sh
	endif
endif
" }}}

" Tame the quickfix window (open/close using ,f) {{{
:nmap <silent> <leader>f :QFix<CR>

:command! -bang -nargs=? QFix call QFixToggle(<bang>0)
:function! QFixToggle(forced)
	:if exists("g:qfix_win") && a:forced == 0
		:cclose
		:unlet g:qfix_win
	:else
		:copen 10
		:let g:qfix_win = bufnr("$")
	:endif
:endfunction
" }}}

" }}}

" Highlighting {{{

:set background=dark

" Use xterm256 colors
if !has("gui_running")
	set t_Co=256
"elseif $COLORTERM == 'gnome-terminal'
"	set term=gnome-256color
endif

:if &t_Co >= 256 || has("gui_running")
	"colorscheme molokai
	:if filereadable($HOME.'/.vim/colors/ir_black_jeffhung.vim')
		:colorscheme ir_black_jeffhung
	:elseif filereadable($HOME.'/.vim/colors/ir_black.vim')
		:colorscheme ir_black
	:endif
:endif

:if &t_Co > 2 || has("gui_running")
	:syntax on                    " switch syntax highlighting on, when the terminal has colors
	:syntax sync fromstart
:endif

" Tuning C syntax highlighting {{{

:let c_minlines = 1000
:let c_comment_strings = 1 " strings and numbers inside a comment
:let c_space_errors    = 1 " trailing white space and spaces before a <Tab>
:let c_curly_error     = 1 " highlight a missing }; this forces syncing from the
                           " start of the file, can be slow
" }}}

" Tuning Java syntax highlighting {{{

" All identifiers in java.lang.* are always visible in all classes.  To
" highlight them use: >
:let java_highlight_java_lang_ids=1

" In Java 1.1 the functions System.out.println() and System.err.println() should
" only be used for debugging.  Therefore it is possible to highlight debugging
" statements differently.  To do this you must add the following definition in
" your startup file: >
:let java_highlight_debug=1
" The result will be that those statements are highlighted as 'Special'
" characters.  If you prefer to have them highlighted differently you must define
" new highlightings for the following groups.:
"     Debug, DebugSpecial, DebugString, DebugBoolean, DebugType
" which are used for the statement itself, special characters used in debug
" strings, strings, boolean constants and types (this, super) respectively.  I
" have opted to chose another background for those statements.

" }}}

" Tuning Perl syntax highlighting {{{

" If you use POD files or POD segments, you might: >
:let perl_include_pod = 1

" }}}

" }}}

" Shortcut mappings {{{

" Since I never use the ; key anyway, this is a real optimization for almost
" all Vim commands, since we don't have to press that annoying Shift key that
" slows the commands down
:nnoremap ; :

" Avoid accidental hits of <F1> while aiming for <Esc>
:map! <F1> <Esc>

" Quickly close the current window
:nnoremap <leader>q :q<CR>

" Use Q for formatting the current paragraph (or visual selection)
:vmap Q gq
:nmap Q gqap

" make p in Visual mode replace the selected text with the yank register
:vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Shortcut to make
"nmap mk :make<CR>

" Swap implementations of ` and ' jump to markers
" By default, ' jumps to the marked line, ` jumps to the marked line and
" column, so swap them
"nnoremap ' `
"nnoremap ` '

" Use the damn hjkl keys
"map <up> <nop>
"map <down> <nop>
"map <left> <nop>
"map <right> <nop>

" Remap j and k to act as expected when used on long, wrapped, lines
:nnoremap j gj
:nnoremap k gk

" Easy window navigation
:map <C-h> <C-w>h
:map <C-j> <C-w>j
:map <C-k> <C-w>k
:map <C-l> <C-w>l
:nnoremap <leader>w <C-w>v<C-w>l

" Complete whole filenames/lines with a quicker shortcut key in insert mode
"imap <C-f> <C-x><C-f>
"imap <C-l> <C-x><C-l>

" Use ,d (or ,dd or ,dj or 20,dd) to delete a line without adding it to the
" yanked stack (also, in visual mode)
:nmap <silent> <leader>d "_d
:vmap <silent> <leader>d "_d

" Quick yanking to the end of the line
:nmap Y y$

" Yank/paste to the OS clipboard with ,y and ,p
:nmap <leader>y "+y
:nmap <leader>Y "+yy
:nmap <leader>p "+p
:nmap <leader>P "+P

" YankRing stuff
:let g:yankring_history_dir = '$HOME/.vim/.tmp'
:nmap <leader>r :YRShow<CR>

" Edit the vimrc file
:nmap <silent> <leader>ev :e $MYVIMRC<CR>
:nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Clears the search register
:nmap <silent> <leader>/ :nohlsearch<CR>

" Quickly get out of insert mode without your fingers having to leave the
" home row (either use 'jj' or 'jk')
"inoremap jj <Esc>
"inoremap jk <Esc>

" Quick alignment of text
:nmap <leader>al :left<CR>
:nmap <leader>ar :right<CR>
:nmap <leader>ac :center<CR>

" Pull word under cursor into LHS of a substitute (for quick search and
" replace)
:nmap <leader>z :%s#\<<C-r>=expand("<cword>")<CR>\>#

" Scratch
:nmap <leader><tab> :Sscratch<CR><C-W>x<C-J>

" Sudo to write
"cmap w!! w !sudo tee % >/dev/null

" Jump to matching pairs easily, with Tab
:nnoremap <Tab> %
:vnoremap <Tab> %

" Folding
:nnoremap <Space> za
:vnoremap <Space> za

" Strip all trailing whitespace from a file, using ,w
:nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Run Ack fast (mind the trailing space here, wouldya?)
:nnoremap <leader>a :Ack 

" Creating folds for tags in HTML
"nnoremap <leader>ft Vatzf

" Reselect text that was just pasted with ,v
:nnoremap <leader>v V`]

" Gundo.vim
:nnoremap <F5> :GundoToggle<CR>
" }}}

" NERDTree settings {{{
" Put focus to the NERD Tree with F3 (tricked by quickly closing it and
" immediately showing it again, since there is no :NERDTreeFocus command)
:nmap <leader>n :NERDTreeClose<CR>:NERDTreeToggle<CR>
:nmap <leader>m :NERDTreeClose<CR>:NERDTreeFind<CR>
:nmap <leader>N :NERDTreeClose<CR>

" Store the bookmarks file
:let NERDTreeBookmarksFile=expand("$HOME/.vim/NERDTreeBookmarks")

" Show the bookmarks table on startup
:let NERDTreeShowBookmarks=1

" Show hidden files, too
:let NERDTreeShowFiles=1
:let NERDTreeShowHidden=1

" Quit on opening files from the tree
:let NERDTreeQuitOnOpen=1

" Highlight the selected entry in the tree
:let NERDTreeHighlightCursorline=1

" Use a single click to fold/unfold directories and a double click to open
" files
:let NERDTreeMouseMode=2

" Don't display these kinds of files
:let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$',
            \ '\.o$', '\.so$', '\.egg$', '^\.git$' ]

" }}}

" TagList settings {{{
" @sa vimscript#273: taglist.vim : Source code browser (supports C/C++, java,
"                    perl, python, tcl, sql, php, etc) 
"     (http://www.vim.org/scripts/script.php?script_id=273)
" @sa http://www.geocities.com/yegappan/taglist/

:nmap <leader>l :TlistClose<CR>:TlistToggle<CR>
:nmap <leader>L :TlistClose<CR>
" creates a normal mode mapping for the <F8> key to toggle the taglist window.
:nnoremap <silent> <F8> :TlistToggle<CR>

" display the tags for only the current active buffer
":let Tlist_Show_One_File = 1 (default: 0)

" automatically close the tags tree for inactive files
" jeffhung.20070712:
" - recommended to use with Tlist_Show_One_File = 0
:let Tlist_File_Fold_Auto_Close = 1 " (default: 0)

" not display the Vim fold column in the taglist window
:let Tlist_Enable_Fold_Column = 0 " (default: 1)

" generate the list of tags for new files even when the taglist window is
" closed and the taglist menu is disabled
" jeffhung.20070712:
" - required for showing prototypes even when taglist window is not open
":let Tlist_Process_File_Always = 1 " (default: 0)

" jeffhung.20070712:
" - recommended to use with Tlist_Process_File_Always = 1
":set statusline=%<%f%=%([%{Tlist_Get_Tag_Prototype_By_Line()}]%)

" show tag prototype instead of tagname in taglist window
":let Tlist_Display_Prototype = 1 " (default: 0)

" display tag scope in square brackets next to the tag name in taglist window
":let Tlist_Display_Tag_Scope = 0 " (default: 1)

" Close Vim if the taglist is the only window.
:let Tlist_Exit_OnlyWindow = 1

" Jump to taglist window on open.
:let Tlist_GainFocus_On_ToggleOpen = 1

" Close the taglist window when a file or tag is selected.
:let Tlist_Close_On_Select = 1

" automatically open the taglist window on Vim startup
:let Tlist_Auto_Open = 0

" sorted either by their 'name' or by their chronological 'order'
:let Tlist_Sort_Type = 'name'

" use a horizontally split taglist window, instead of a vertically split window
":let Tlist_Use_Horiz_Window = 1

" specify the height of the horizontally split taglist window
":let Tlist_WinHeight = 12

" use a vertically split taglist window on the rightmost side of the Vim window
:let Tlist_Use_Right_Window = 1

" specify the width of the vertically split taglist window
:let Tlist_WinWidth = 53

" increase window width when taglist window is open
" XXX set to 0 in MSWin32
:let Tlist_Inc_Winwidth = 0 " (default: 1)

" jump to a tag when you single click on the tag name using the mouse
":let Tlist_Use_SingleClick = 1 " (default: 0)

" automatically highlight the current tag in the taglist window
":let Tlist_Auto_Highlight_Tag = 0 " (default: 1)

" automatically highlight the current tag in the taglist window when
" entering a Vim buffer/window
":let Tlist_Highlight_Tag_On_BufEnter = 0 " (default: 1)

" display as many tags as possible in the taglist window with compact display
:let Tlist_Compact_Format = 1 " (default: 0)

" shorten the time it takes to highlight the current tag (default is 4 secs)
" note that this setting influences Vim's behaviour when saving swap files,
" but we have already turned off swap files (earlier)
"set updatetime=1000

" the default ctags in /usr/bin on the Mac is GNU ctags, so change it to the
" exuberant ctags version in /usr/local/bin
:let Tlist_Ctags_Cmd = ctags_cmd.' '.ctags_opts

" }}}

" Conflict markers {{{
" highlight conflict markers
:match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" shortcut to jump to next conflict marker
:nmap <silent> <leader>c /^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>
" }}}

" Filetype specific handling {{{
" only do this part when compiled with support for autocommands
:if has("autocmd")

	:augroup invisible_chars "{{{
		:au!

		" Show invisible characters in all of these files
		:autocmd filetype vim setlocal list
		:autocmd filetype python,rst setlocal list
		:autocmd filetype ruby setlocal list
		:autocmd filetype javascript,css setlocal list
	augroup end "}}}

	:augroup vim_files "{{{
		:au!

		" Bind <F1> to show the keyword under cursor
		" general help can still be entered manually, with :h
		:autocmd filetype vim noremap <buffer> <F1> <Esc>:help <C-r><C-w><CR>
		:autocmd filetype vim noremap! <buffer> <F1> <Esc>:help <C-r><C-w><CR>
	:augroup end "}}}

	:augroup html_files "{{{
		:au!

		" This function detects, based on HTML content, whether this is a
		" Django template, or a plain HTML file, and sets filetype accordingly
		:fun! s:DetectHTMLVariant()
			:let n = 1
			:while n < 50 && n < line("$")
				" check for django
				:if getline(n) =~ '{%\s*\(extends\|load\|block\|if\|for\|include\|trans\)\>'
					:set ft=htmldjango.html
					:return
				:endif
				:let n = n + 1
			:endwhile
			:" go with html
			:set filetype=html
		:endfun

		:autocmd BufNewFile,BufRead *.html,*.htm call s:DetectHTMLVariant()

"		" Auto-closing of HTML/XML tags
"		:let g:closetag_default_xml=1
"		:autocmd filetype html,htmldjango let b:closetag_html_style=1
"		:autocmd filetype html,xhtml,xml source ~/.vim/scripts/closetag.vim

"		" Enable Sparkup for lightning-fast HTML editing
"		:let g:sparkupExecuteMapping = '<leader>e'
	:augroup end " }}}

	:augroup python_files "{{{
		:au!

		:" This function detects, based on Python content, whether this is a
		:" Django file, which may enabling snippet completion for it
		:fun! s:DetectPythonVariant()
			:let n = 1
			:while n < 50 && n < line("$")
				:" check for django
				:if getline(n) =~ 'import\s\+\<django\>'
					:set filetype=python.django
"					:set syntax=python
					:return
				:endif
				:let n = n + 1
			:endwhile
            " go with html
			:set ft=python
		:endfun
		:autocmd BufNewFile,BufRead *.py call s:DetectPythonVariant()

        " PEP8 compliance (set 1 tab = 4 chars explicitly, even if set
        " earlier, as it is important)
		:autocmd filetype python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
		:autocmd filetype python setlocal textwidth=80
		:autocmd filetype python match ErrorMsg '\%>80v.\+'

		:" But disable autowrapping as it is super annoying
		:autocmd filetype python setlocal formatoptions-=t

"		" Folding for Python (uses syntax/python.vim for fold definitions)
"		:autocmd filetype python,rst setlocal nofoldenable
"		:autocmd filetype python setlocal foldmethod=expr

		" Python runners
		:autocmd filetype python map <buffer> <F5> :w<CR>:!python %<CR>
		:autocmd filetype python imap <buffer> <F5> <Esc>:w<CR>:!python %<CR>
		:autocmd filetype python map <buffer> <S-F5> :w<CR>:!ipython %<CR>
		:autocmd filetype python imap <buffer> <S-F5> <Esc>:w<CR>:!ipython %<CR>

"		" Run a quick static syntax check every time we save a Python file
"		:autocmd BufWritePost *.py call Pyflakes()
	:augroup end " }}}

	:augroup ruby_files "{{{
		:au!

		:autocmd filetype ruby setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
	:augroup end " }}}

	:augroup rst_files "{{{
		:au!

		" Auto-wrap text around 74 chars
		:autocmd filetype rst setlocal textwidth=74
		:autocmd filetype rst setlocal formatoptions+=nqt
		:autocmd filetype rst match ErrorMsg '\%>74v.\+'
	:augroup end " }}}

	:augroup css_files "{{{
		:au!

		:autocmd filetype css,less setlocal foldmethod=marker foldmarker={,}
	:augroup end "}}}

	:augroup javascript_files "{{{
		:au!

"		:autocmd filetype javascript setlocal expandtab
"		:autocmd filetype javascript setlocal listchars=trail:·,extends:#,nbsp:·
		:autocmd filetype javascript setlocal foldmethod=marker foldmarker={,}
	:augroup end "}}}

	:augroup textile_files "{{{
		:au!

		:autocmd filetype textile set tw=78 wrap

		" Render YAML front matter inside Textile documents as comments
		:autocmd filetype textile syntax region frontmatter start=/\%^---$/ end=/^---$/
		:autocmd filetype textile highlight link frontmatter Comment
	:augroup end "}}}

:endif
" }}}

" Skeleton processing {{{

:if has("autocmd")

	:if !exists('*LoadTemplate')
		:function LoadTemplate(file)
			" Add skeleton fillings for Python (normal and unittest) files
			:if a:file =~ 'test_.*\.py$'
				:execute "0r ~/.vim/skeleton/test_template.py"
			:elseif a:file =~ '.*\.py$'
				:execute "0r ~/.vim/skeleton/template.py"
			:endif
		:endfunction
	:endif

	:autocmd BufNewFile * call LoadTemplate(@%)

:endif " has("autocmd")

" }}}

" Restore cursor position upon reopening files {{{
:autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

"" ----------------------------------------------------------------------------
"" Save current editing location and resume when open again.
"" ----------------------------------------------------------------------------
"if has("autocmd")
""	autocmd BufRead *.txt set tw=78
"	autocmd BufReadPost *
"		\ if line("'\"") > 0 && line("'\"") <= line("$") |
"		\	exe "normal g'\"" |
"		\ endif
"endif
"" }}}
"
"" Common abbreviations / misspellings {{{
":if filereadable($HOME.'/.vim/autocorrect.vim')
"	:source ~/.vim/autocorrect.vim
":endif

" }}}

" Extra vi-compatibility {{{
" set extra vi-compatible options
:set cpoptions+=$     " when changing a line, don't redisplay, but put a '$' at
                      " the end during the change
:set formatoptions-=o " don't start new lines w/ comment leader on pressing 'o'
:au filetype vim set formatoptions-=o
                      " somehow, during vim filetype detection, this gets set
                      " for vim files, so explicitly unset it again
" }}}

" Extra user or machine specific settings {{{
:if filereadable($HOME.'/.vim/user.vim')
	:source ~/.vim/user.vim
:endif
" }}}

" Creating underline/overline headings for markup languages {{{
" Inspired by http://sphinx.pocoo.org/rest.html#sections
:nnoremap <leader>1 yyPVr=jyypVr=
:nnoremap <leader>2 yyPVr*jyypVr*
:nnoremap <leader>3 yypVr=
:nnoremap <leader>4 yypVr-
:nnoremap <leader>5 yypVr^
:nnoremap <leader>6 yypVr"

:iab lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit
:iab llorem Lorem ipsum dolor sit amet, consectetur adipiscing elit.  Etiam lacus ligula, accumsan id imperdiet rhoncus, dapibus vitae arcu.  Nulla non quam erat, luctus consequat nisi
:iab lllorem Lorem ipsum dolor sit amet, consectetur adipiscing elit.  Etiam lacus ligula, accumsan id imperdiet rhoncus, dapibus vitae arcu.  Nulla non quam erat, luctus consequat nisi.  Integer hendrerit lacus sagittis erat fermentum tincidunt.  Cras vel dui neque.  In sagittis commodo luctus.  Mauris non metus dolor, ut suscipit dui.  Aliquam mauris lacus, laoreet et consequat quis, bibendum id ipsum.  Donec gravida, diam id imperdiet cursus, nunc nisl bibendum sapien, eget tempor neque elit in tortor
" }}}

" vimwiki (http://code.google.com/p/vimwiki) {{{

:if filereadable($HOME.'/.vim/plugin/vimwiki.vim') || filereadable($HOME.'/.vim/bundle/vimwiki/plugin/vimwiki.vim')
	:autocmd BufNewFile,BufRead *.wiki set tabstop=2
	:autocmd BufNewFile,BufRead *.wiki set softtabstop=2
	:autocmd BufNewFile,BufRead *.wiki set foldlevel=1
	:map <leader>tt <Plug>VimwikiToggleListItem

	"
	" Global options
	"

	" This affects WikiWord detection. By default WikiWord detection uses
	" English and Russian letters.
	:let g:vimwiki_upper           = "\-A-Z\u0410-\u042f"
	:let g:vimwiki_lower           = "\-a-z\u0430-\u044f"

	" Highlight checked [X] check box with |group-name| "Comment".
	:let g:vimwiki_hl_cb_checked   = 1

	" Use local mouse mappings from |vimwiki-local-mappings|.
	:let g:vimwiki_use_mouse       = 1

	" Enable/disable vimwiki's folding/outline. Folding in vimwiki is using
	" 'expr' foldmethod which is very flexible but really slow.
	:let g:vimwiki_folding         = 1

"	" Enable list subitem's folding.
"	:let g:vimwiki_fold_lists      = 1

"	" Fold only one empty line. The rest empty lines are unfolded.
"	:let g:vimwiki_fold_trailing_empty_lines = 1

	" Use special method to calculate correct length of the strings with double
	" wide characters. (To align table cells properly)
	:let g:vimwiki_CJK_length      = 1

	" Set this option if you want headers to be auto numbered in html.
	:let g:vimwiki_html_header_numbering = 2
	" Ending symbol for g:vimwiki_html_header_numbering.
	:let g:vimwiki_html_header_numbering = '.'

	"
	" The "main" wiki
	"

	:let wiki_main                 = {}
	:let wiki_main.path            = '~/Dropbox/vimwiki/data/'
	:let wiki_main.path_html       = '~/Dropbox/vimwiki/html/'
	:let wiki_main.auto_export     = 1
	:let wiki_main.html_header     = '~/Dropbox/vimwiki/html/header.tpl'
	:let wiki_main.html_footer     = '~/Dropbox/vimwiki/html/footer.tpl'
"	:let wiki_main.nested_syntaxes = {'python': 'python', 'c++': 'cpp' }
"	:let wiki_main.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'sql': 'sql' }
	:let wiki_main.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'sql': 'sql', 'java': 'java' }

	"
	" The "coretech" wiki
	"

	:let wiki_coretech                 = {}
	:let wiki_coretech.syntax          = 'media'
	:let wiki_coretech.path            = '~/Dropbox/coretech-wiki/data/'
	:let wiki_coretech.path_html       = '~/Dropbox/coretech-wiki/html/'
"	:let wiki_coretech.auto_export     = 1
	:let wiki_coretech.html_header     = '~/Dropbox/coretech-wiki/html/header.tpl'
	:let wiki_coretech.html_footer     = '~/Dropbox/coretech-wiki/html/footer.tpl'
"	:let wiki_coretech.nested_syntaxes = {'python': 'python', 'c++': 'cpp' }
"	:let wiki_coretech.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'sql': 'sql' }
	:let wiki_coretech.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'sql': 'sql', 'java': 'java' }

	" Register all wiki
	:let g:vimwiki_list = [ wiki_main, wiki_coretech ]
:endif

" }}}

" DoxyGen Syntax (http://www.vim.org/scripts/script.php?script_id=5) {{{
:autocmd BufNewFile,BufRead *.doxygen setfiletype doxygen
":if filereadable('~/.vim/syntax/doxygen_load.vim')
"	" Must before :syntax enable
"	:let mysyntaxfile='~/.vim/syntax/doxygen_load.vim';
":endif
":let g:doxygen_enhanced_colour
" }}}

" jQuery (http://www.vim.org/scripts/script.php?script_id=2416) {{{
:if filereadable($HOME.'/.vim/syntax/jquery.vim')
	:autocmd BufRead,BufNewFile *.js set filetype=javascript.jquery
:endif
" }}}

" Default *.jz file to jz syntax {{{
:autocmd BufNewFile,BufRead *.jz set filetype=jz
" }}}

" Show current editing file in (screen's) window title. {{{
" @sa http://blog.rafan.org/archives/145

":if $TERM == 'screen'
"	:set t_ts=k
"	:set t_fs=\
""	:autocmd BufEnter * :set title | :let &titlestring='[vim]'.expand('%:t')
"	:autocmd BufEnter * :set title | :let &titlestring='%([vim]%)%<%F' | :let titlelen=20
"	:autocmd VimLeave * :set notitle
":endif

" }}}

" Open in new tab for :tag and :tselect {{{
" @sa http://c9s.blogspot.com/2007/07/vim-tips-tag.html
"     "其中 viw 就是利用 Visual Mode 將自選起來，用 y 複製到暫存器(Register)，
"     接著使用 :tab tag 作分頁動作， <C-R>" 則是把 Register 內的值抓出來，
"     <CR> 等於Enter。"
:if (v:version >= 700)
	:nmap <C-]> viwy:tab tag <C-R>"<CR>
	:nmap g]    viwy:tab tselect <C-R>"<CR>
:endif
" }}}

" Indent in visual mode using <tab> and <s-tab> {{{
" @sa http://c9s.blogspot.com/2007/10/vim-tips.html
"     "在 Visual Block Mode , Normal Mode 按一下 Tab 或是 Shift-Tab 就可以方便
"     的調整縮排了。"

"nmap <Tab>   V>
"nmap <S-Tab> V<
"xmap <Tab>   >gv
"xmap <S-Tab> <gv

"}}}

" a.vim: Alternate Files quickly (.c --> .h etc) {{{
" (http://www.vim.org/scripts/script.php?script_id=31)
" A few of quick commands to swtich between source files and header files quickly.

if exists("loaded_alternateFile")
	" default: 'sfr:../source,sfr:../src,sfr:../include,sfr:../inc'
	:let g:alternateSearchPath = 'include:src:../include:../src:reg:|src/\([^/]*\)|inc/\1'
endif
" }}}

" TaskList.vim : Eclipse like task list {{{
" (http://www.vim.org/scripts/script.php?script_id=2607)
" This script is based on the eclipse Task List. It will search the file for
" FIXME, TODO, and XXX (or a custom list) and put them in a handy list for you
" to browse which at the same time will update the location in the document so
" you can see exactly where the tag is located. Something like an interactive
" 'cw'
:if exists("g:loaded_tasklist")
	:let g:tlRememberPosition = 1
:endif
"}}}

" VimTip 2: easy edit of files in the same directory {{{
" http://vim.sourceforge.net/tip_view.php?tip_id=
"
" It was often frustrating when I would open a file deep in the code tree and
" then realize I wanted to open another file in that same directory. Douglas
" Potts taught me a nice way to do this. Add the following snipit to your
" vimrc:
"
" "   Edit another file in the same directory as the current file
" "   uses expression to extract path from current file's path
" "  (thanks Douglas Potts)
" if has("unix")
"     map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
" else
"     map ,e :e <C-R>=expand("%:p:h") . "\" <CR>
" endif
" 
" Then when you type ,e in normal mode you can use tab to complete to the
" file. You can also expand this to allow for spitting, etc. Very very nice.
"
" jeffhung.20070809:
" - Use uppercase E instead of lowercase e to open in another tab.

:if has("unix")
	:map ,e :E <C-R>=expand("%:p:h") . "/" <CR>
:else
	:map ,e :E <C-R>=expand("%:p:h") . "\\" <CR>
:endif
" }}}

" Reload the same file in different encoding {{{
" @note jeffhung.20060405: This function doesn't work.  Why?
" @sa vimtip#1195: Reload the same file in different encoding
"     (http://www.vim.org/tips/tip.php?tip_id=1195)

"function! ChangeFileEncoding()
"	let encodings = ['utf-8', 'big5', 'euc-tw', 'cp950', 'utf8', 'euc-cn', 'cp936', 'ucs-2', 'ucs-2be', 'ucs-2le', 'utf-16', 'utf-16be', 'utf-16le', 'ucs-4', 'ucs-4le', 'latin1']
"	let prompt_encs = []
"	let index = 0
"	while index < len(encodings)
"		call add(prompt_encs, index.'. '.encodings[index])
"		let index = index + 1
"	endwhile
"	let choice = inputlist(prompt_encs)
"	if choice >= 0 && choice < len(encodings)
"		execute 'e ++enc='.encodings[choice].' %:p'
"	endif
"endf
"nmap <f8> :call ChangeFileEncoding()<cr>
" }}}

" Make buffer modifiable state match file readonly state {{{
" @sa vimtip#1238: Make buffer modifiable state match file readonly state
"     (http://www.vim.org/tips/tip.php?tip_id=1238)

:function! UpdateModifiable()
	:if !exists("b:setmodifiable")
		:let b:setmodifiable = 0
	:endif
	:if &readonly
		:if &modifiable
			:setlocal nomodifiable
			:let b:setmodifiable = 1
		:endif
	:else
		:if b:setmodifiable
			:setlocal modifiable
		:endif
	:endif
:endfunction

:autocmd BufReadPost * call UpdateModifiable()

" }}}

" Read the wxWindows syntax to start with {{{
" @bug jeffhung.20060525: By instruction, we need to append the following code
"      to $VIMRUNTIME/syntax/cpp.vim.  But it will be override once we upgrade
"      VIM.  We should find a way to inject the effect from ~/.vimrc if file
"      type is C/C++.
" @sa http://www.wxwidgets.org/wiki/index.php/VIM

"if version < 600
"	so <sfile>:p:h/wxwin.vim
"else
"	runtime! syntax/wxwin.vim
"	unlet b:current_syntax
"endif
" }}}

" Tab navigation like firefox {{{
" @sa vimtip#1221: Alternative tab navigation
"     (http://www.vim.org/tips/tip.php?tip_id=1221)
" jeffhung.20060531:
" - <C-t> will conflict with "jumping to previous tags".
" - This doesn't work.

"if version >= 700
"	" Go to previous tab.
"	:nmap <C-S-tab> :tabprevious<cr>
"	:map  <C-S-tab> :tabprevious<cr>
"	:imap <C-S-tab> <ESC>:tabprevious<cr>i
"	" Go to next tab.
"	:nmap <C-tab>   :tabnext<cr>
"	:map  <C-tab>   :tabnext<cr>
"	:imap <C-tab>   <ESC>:tabnext<cr>i
"	" New a tab
"	:nmap <C-t>     :tabnew<cr>
"	:imap <C-t>     <ESC>:tabnew<cr> 
"endif
"}}}

" Tune cppomnicomplete support. {{{
" @sa vimscript#1520: CppOmniComplete : C++ completion omnifunc with a ctags
"                     database 
"     (http://www.vim.org/scripts/script.php?script_id=1520)

" Map F12 to ctags to generate tags file used by CppOmniComplete, silently
:if (executable('exctags'))
	" - The complex exctags arguments are already specified in CTAGS environment
	"   variable.
	" jeffhung.20080319:
	" - No, cmd.exe is used for invoking ctags command, so we will not get
	"   CTAGS from ~/.cshrc.
	:map <F12> :silent !exctags --c-kinds=+lpx --c++-kinds=+lpx --fields=+ailmS --extra=+fq --recurse .<CR><C-L>
:elseif (executable('ctags'))
	" - We may get trouble if ctags is not exuberant-ctags.
	:map <F12> :silent !ctags --c-kinds=+lpx --c++-kinds=+lpx --fields=+ailmS --extra=+fq --recurse .<CR><C-L>
:endif

:if version >= 700
	" A comma separated list of options for Insert mode completion ins-
	" completion.  The supported values are:
	"
	"   menu    Use a popup menu to show the possible completions.  The
	"           menu is only shown when there is more than one match and
	"           sufficient colors are available.  |ins-completion-menu|
	"   menuone Use the popup menu also when there is only one match.
	"           Useful when there is additional information about the
	"           match, e.g., what file it comes from.
	"   longest Only insert the longest common text of the matches.  If
	"           the menu is displayed you can use CTRL-L to add more
	"           characters.  Whether case is ignored depends on the kind
	"           of completion.  For buffer text the 'ignorecase' option is
	"           used.
	"   preview Show extra information about the currently selected
	"           completion in the preview window.
	:set completeopt=menu,longest,preview

	" Show scope at the beginning of the symbol instead of at the last column.
	":let CppOmni_ShowScopeInAbbr=1

	" Let the auto-completion box more clear
	:highlight PmenuSel term=bold cterm=bold ctermfg=7 ctermbg=4

	" Force the preview window be 7-row hight.  This height would be enough for
	" function preview, too.
	:set previewheight=7

	" Automatically show preview when cursor hold for updatetime micro-seconds.
	":au! CursorHold *.[ch] nested exe "silent! ptag " . expand("<cword>")

	" Let's see the preview more quickly.
	":set updatetime=500
:endif

" }}}

" Enable AutoTag support. {{{
" @sa vimscript#1343: AutoTag : Updates entries in a tags file automatically
"                     when saving
"     (http://www.vim.org/scripts/script.php?script_id=1343)

" jeffhung.20070906: AutoTag may corrupt existing tags file (different range).
":if filereadable("~/.vim/plugin/autotag.vim")
"	:if !has("win32")
"		let g:autotagVerbosityLevel=1
"		let g:autotagExcludeSuffixes="tml.xml.html.htm"
"		:if (executable('exctags'))
"			" - The complex exctags arguments are already specified in CTAGS environment
"			"   variable.
"			:let g:autotagCtagsCmd = 'exctags'
"		:elseif (executable('ctags'))
"			" - We may get trouble if ctags is not exuberant-ctags.
"			:let g:autotagCtagsCmd = 'ctags'
"		:endif
"		" - The complex exctags arguments are already specified in CTAGS environment
"		"   variable.
"		" - Because the AutoTag plugin was written in python, which will launch ctags
"		"   via os.popen2(), which will run ctags in default shell: sh.  Thus, the
"		"   aliasing of ctags=exctags that defined in csh.cshrc does not work.  So, we
"		"   have to explicitly use exctags here.
"		":let g:autotagCtagsCmd="exctags"
"		source ~/.vim/plugin/autotag.vim
"	:endif " if (!win32)
":endif " if (autotag installed)
" }}}

" @sa vimscript#1347: quick tab navigation and opening {{{
"     (http://www.vim.org/tips/tip.php?tip_id=1347)

"if version >= 700
"	:map <C-t>     :tabnew<CR>
"	:map <C-left>  :tabp<CR>
"	:map <C-right> :tabn<CR>
"endif

" }}}

" Change behaviour of builtin commands like :e using special case of cabbrev {{{
" @sa vimscript#1285: Change behaviour of builtin commands like :e using special
"     case of cabbrev
"     (http://www.vim.org/scripts/script.php?script_id=1285)

:if (v:version >= 700)
	:command! -nargs=* -complete=file E if expand('%')=='' && line('$')==1 && getline(1)=='' | :edit <args> | else | :tabnew <args> | endif
	:cabbrev e <c-R>=(getcmdtype()==':' && getcmdpos()==1 ? 'E' : 'e')<cr>
:endif
" }}}

" Highlight cursor line after cursor jump (for easy spot) {{{
" @sa vimscript#1380: Highlight cursor line after cursor jump (for easy spot)
"     (http://www.vim.org/scripts/script.php?script_id=1380)

":function s:HighlightCursorLineOnCursorJump()
"	:let cur_pos= line ('.')
"
"	:if g:HCLOCJ_last_pos==0
"		:set cursorline
"		:let g:HCLOCJ_last_pos=cur_pos
"		:return
"	:endif
"
"	:let diff= g:HCLOCJ_last_pos - cur_pos
"
"	:if diff > 1 || diff < -1
"		:set cursorline
"	:else
"		:set nocursorline
"	:end
"
"	:let g:HCLOCJ_last_pos=cur_pos
":endfunction
"
":autocmd CursorMoved,CursorMovedI * call s:HighlightCursorLineOnCursorJump()
":let g:HCLOCJ_last_pos=0

" }}}

" xterm256 color names for console vim. {{{
" @sa vimscript#1384: xterm256 color names for console vim.
"     (http://www.vim.org/scripts/script.php?script_id=1384)
" Generated from c:/pdsrc/xterm-222/256colres.h by allcolors.pl
:highlight x016_Grey0                ctermfg=16  guifg=#000000
:highlight x017_NavyBlue             ctermfg=17  guifg=#00005f
:highlight x018_DarkBlue             ctermfg=18  guifg=#000087
:highlight x019_Blue3                ctermfg=19  guifg=#0000af
:highlight x020_Blue3                ctermfg=20  guifg=#0000d7
:highlight x021_Blue1                ctermfg=21  guifg=#0000ff
:highlight x022_DarkGreen            ctermfg=22  guifg=#005f00
:highlight x023_DeepSkyBlue4         ctermfg=23  guifg=#005f5f
:highlight x024_DeepSkyBlue4         ctermfg=24  guifg=#005f87
:highlight x025_DeepSkyBlue4         ctermfg=25  guifg=#005faf
:highlight x026_DodgerBlue3          ctermfg=26  guifg=#005fd7
:highlight x027_DodgerBlue2          ctermfg=27  guifg=#005fff
:highlight x028_Green4               ctermfg=28  guifg=#008700
:highlight x029_SpringGreen4         ctermfg=29  guifg=#00875f
:highlight x030_Turquoise4           ctermfg=30  guifg=#008787
:highlight x031_DeepSkyBlue3         ctermfg=31  guifg=#0087af
:highlight x032_DeepSkyBlue3         ctermfg=32  guifg=#0087d7
:highlight x033_DodgerBlue1          ctermfg=33  guifg=#0087ff
:highlight x034_Green3               ctermfg=34  guifg=#00af00
:highlight x035_SpringGreen3         ctermfg=35  guifg=#00af5f
:highlight x036_DarkCyan             ctermfg=36  guifg=#00af87
:highlight x037_LightSeaGreen        ctermfg=37  guifg=#00afaf
:highlight x038_DeepSkyBlue2         ctermfg=38  guifg=#00afd7
:highlight x039_DeepSkyBlue1         ctermfg=39  guifg=#00afff
:highlight x040_Green3               ctermfg=40  guifg=#00d700
:highlight x041_SpringGreen3         ctermfg=41  guifg=#00d75f
:highlight x042_SpringGreen2         ctermfg=42  guifg=#00d787
:highlight x043_Cyan3                ctermfg=43  guifg=#00d7af
:highlight x044_DarkTurquoise        ctermfg=44  guifg=#00d7d7
:highlight x045_Turquoise2           ctermfg=45  guifg=#00d7ff
:highlight x046_Green1               ctermfg=46  guifg=#00ff00
:highlight x047_SpringGreen2         ctermfg=47  guifg=#00ff5f
:highlight x048_SpringGreen1         ctermfg=48  guifg=#00ff87
:highlight x049_MediumSpringGreen    ctermfg=49  guifg=#00ffaf
:highlight x050_Cyan2                ctermfg=50  guifg=#00ffd7
:highlight x051_Cyan1                ctermfg=51  guifg=#00ffff
:highlight x052_DarkRed              ctermfg=52  guifg=#5f0000
:highlight x053_DeepPink4            ctermfg=53  guifg=#5f005f
:highlight x054_Purple4              ctermfg=54  guifg=#5f0087
:highlight x055_Purple4              ctermfg=55  guifg=#5f00af
:highlight x056_Purple3              ctermfg=56  guifg=#5f00d7
:highlight x057_BlueViolet           ctermfg=57  guifg=#5f00ff
:highlight x058_Orange4              ctermfg=58  guifg=#5f5f00
:highlight x059_Grey37               ctermfg=59  guifg=#5f5f5f
:highlight x060_MediumPurple4        ctermfg=60  guifg=#5f5f87
:highlight x061_SlateBlue3           ctermfg=61  guifg=#5f5faf
:highlight x062_SlateBlue3           ctermfg=62  guifg=#5f5fd7
:highlight x063_RoyalBlue1           ctermfg=63  guifg=#5f5fff
:highlight x064_Chartreuse4          ctermfg=64  guifg=#5f8700
:highlight x065_DarkSeaGreen4        ctermfg=65  guifg=#5f875f
:highlight x066_PaleTurquoise4       ctermfg=66  guifg=#5f8787
:highlight x067_SteelBlue            ctermfg=67  guifg=#5f87af
:highlight x068_SteelBlue3           ctermfg=68  guifg=#5f87d7
:highlight x069_CornflowerBlue       ctermfg=69  guifg=#5f87ff
:highlight x070_Chartreuse3          ctermfg=70  guifg=#5faf00
:highlight x071_DarkSeaGreen4        ctermfg=71  guifg=#5faf5f
:highlight x072_CadetBlue            ctermfg=72  guifg=#5faf87
:highlight x073_CadetBlue            ctermfg=73  guifg=#5fafaf
:highlight x074_SkyBlue3             ctermfg=74  guifg=#5fafd7
:highlight x075_SteelBlue1           ctermfg=75  guifg=#5fafff
:highlight x076_Chartreuse3          ctermfg=76  guifg=#5fd700
:highlight x077_PaleGreen3           ctermfg=77  guifg=#5fd75f
:highlight x078_SeaGreen3            ctermfg=78  guifg=#5fd787
:highlight x079_Aquamarine3          ctermfg=79  guifg=#5fd7af
:highlight x080_MediumTurquoise      ctermfg=80  guifg=#5fd7d7
:highlight x081_SteelBlue1           ctermfg=81  guifg=#5fd7ff
:highlight x082_Chartreuse2          ctermfg=82  guifg=#5fff00
:highlight x083_SeaGreen2            ctermfg=83  guifg=#5fff5f
:highlight x084_SeaGreen1            ctermfg=84  guifg=#5fff87
:highlight x085_SeaGreen1            ctermfg=85  guifg=#5fffaf
:highlight x086_Aquamarine1          ctermfg=86  guifg=#5fffd7
:highlight x087_DarkSlateGray2       ctermfg=87  guifg=#5fffff
:highlight x088_DarkRed              ctermfg=88  guifg=#870000
:highlight x089_DeepPink4            ctermfg=89  guifg=#87005f
:highlight x090_DarkMagenta          ctermfg=90  guifg=#870087
:highlight x091_DarkMagenta          ctermfg=91  guifg=#8700af
:highlight x092_DarkViolet           ctermfg=92  guifg=#8700d7
:highlight x093_Purple               ctermfg=93  guifg=#8700ff
:highlight x094_Orange4              ctermfg=94  guifg=#875f00
:highlight x095_LightPink4           ctermfg=95  guifg=#875f5f
:highlight x096_Plum4                ctermfg=96  guifg=#875f87
:highlight x097_MediumPurple3        ctermfg=97  guifg=#875faf
:highlight x098_MediumPurple3        ctermfg=98  guifg=#875fd7
:highlight x099_SlateBlue1           ctermfg=99  guifg=#875fff
:highlight x100_Yellow4              ctermfg=100 guifg=#878700
:highlight x101_Wheat4               ctermfg=101 guifg=#87875f
:highlight x102_Grey53               ctermfg=102 guifg=#878787
:highlight x103_LightSlateGrey       ctermfg=103 guifg=#8787af
:highlight x104_MediumPurple         ctermfg=104 guifg=#8787d7
:highlight x105_LightSlateBlue       ctermfg=105 guifg=#8787ff
:highlight x106_Yellow4              ctermfg=106 guifg=#87af00
:highlight x107_DarkOliveGreen3      ctermfg=107 guifg=#87af5f
:highlight x108_DarkSeaGreen         ctermfg=108 guifg=#87af87
:highlight x109_LightSkyBlue3        ctermfg=109 guifg=#87afaf
:highlight x110_LightSkyBlue3        ctermfg=110 guifg=#87afd7
:highlight x111_SkyBlue2             ctermfg=111 guifg=#87afff
:highlight x112_Chartreuse2          ctermfg=112 guifg=#87d700
:highlight x113_DarkOliveGreen3      ctermfg=113 guifg=#87d75f
:highlight x114_PaleGreen3           ctermfg=114 guifg=#87d787
:highlight x115_DarkSeaGreen3        ctermfg=115 guifg=#87d7af
:highlight x116_DarkSlateGray3       ctermfg=116 guifg=#87d7d7
:highlight x117_SkyBlue1             ctermfg=117 guifg=#87d7ff
:highlight x118_Chartreuse1          ctermfg=118 guifg=#87ff00
:highlight x119_LightGreen           ctermfg=119 guifg=#87ff5f
:highlight x120_LightGreen           ctermfg=120 guifg=#87ff87
:highlight x121_PaleGreen1           ctermfg=121 guifg=#87ffaf
:highlight x122_Aquamarine1          ctermfg=122 guifg=#87ffd7
:highlight x123_DarkSlateGray1       ctermfg=123 guifg=#87ffff
:highlight x124_Red3                 ctermfg=124 guifg=#af0000
:highlight x125_DeepPink4            ctermfg=125 guifg=#af005f
:highlight x126_MediumVioletRed      ctermfg=126 guifg=#af0087
:highlight x127_Magenta3             ctermfg=127 guifg=#af00af
:highlight x128_DarkViolet           ctermfg=128 guifg=#af00d7
:highlight x129_Purple               ctermfg=129 guifg=#af00ff
:highlight x130_DarkOrange3          ctermfg=130 guifg=#af5f00
:highlight x131_IndianRed            ctermfg=131 guifg=#af5f5f
:highlight x132_HotPink3             ctermfg=132 guifg=#af5f87
:highlight x133_MediumOrchid3        ctermfg=133 guifg=#af5faf
:highlight x134_MediumOrchid         ctermfg=134 guifg=#af5fd7
:highlight x135_MediumPurple2        ctermfg=135 guifg=#af5fff
:highlight x136_DarkGoldenrod        ctermfg=136 guifg=#af8700
:highlight x137_LightSalmon3         ctermfg=137 guifg=#af875f
:highlight x138_RosyBrown            ctermfg=138 guifg=#af8787
:highlight x139_Grey63               ctermfg=139 guifg=#af87af
:highlight x140_MediumPurple2        ctermfg=140 guifg=#af87d7
:highlight x141_MediumPurple1        ctermfg=141 guifg=#af87ff
:highlight x142_Gold3                ctermfg=142 guifg=#afaf00
:highlight x143_DarkKhaki            ctermfg=143 guifg=#afaf5f
:highlight x144_NavajoWhite3         ctermfg=144 guifg=#afaf87
:highlight x145_Grey69               ctermfg=145 guifg=#afafaf
:highlight x146_LightSteelBlue3      ctermfg=146 guifg=#afafd7
:highlight x147_LightSteelBlue       ctermfg=147 guifg=#afafff
:highlight x148_Yellow3              ctermfg=148 guifg=#afd700
:highlight x149_DarkOliveGreen3      ctermfg=149 guifg=#afd75f
:highlight x150_DarkSeaGreen3        ctermfg=150 guifg=#afd787
:highlight x151_DarkSeaGreen2        ctermfg=151 guifg=#afd7af
:highlight x152_LightCyan3           ctermfg=152 guifg=#afd7d7
:highlight x153_LightSkyBlue1        ctermfg=153 guifg=#afd7ff
:highlight x154_GreenYellow          ctermfg=154 guifg=#afff00
:highlight x155_DarkOliveGreen2      ctermfg=155 guifg=#afff5f
:highlight x156_PaleGreen1           ctermfg=156 guifg=#afff87
:highlight x157_DarkSeaGreen2        ctermfg=157 guifg=#afffaf
:highlight x158_DarkSeaGreen1        ctermfg=158 guifg=#afffd7
:highlight x159_PaleTurquoise1       ctermfg=159 guifg=#afffff
:highlight x160_Red3                 ctermfg=160 guifg=#d70000
:highlight x161_DeepPink3            ctermfg=161 guifg=#d7005f
:highlight x162_DeepPink3            ctermfg=162 guifg=#d70087
:highlight x163_Magenta3             ctermfg=163 guifg=#d700af
:highlight x164_Magenta3             ctermfg=164 guifg=#d700d7
:highlight x165_Magenta2             ctermfg=165 guifg=#d700ff
:highlight x166_DarkOrange3          ctermfg=166 guifg=#d75f00
:highlight x167_IndianRed            ctermfg=167 guifg=#d75f5f
:highlight x168_HotPink3             ctermfg=168 guifg=#d75f87
:highlight x169_HotPink2             ctermfg=169 guifg=#d75faf
:highlight x170_Orchid               ctermfg=170 guifg=#d75fd7
:highlight x171_MediumOrchid1        ctermfg=171 guifg=#d75fff
:highlight x172_Orange3              ctermfg=172 guifg=#d78700
:highlight x173_LightSalmon3         ctermfg=173 guifg=#d7875f
:highlight x174_LightPink3           ctermfg=174 guifg=#d78787
:highlight x175_Pink3                ctermfg=175 guifg=#d787af
:highlight x176_Plum3                ctermfg=176 guifg=#d787d7
:highlight x177_Violet               ctermfg=177 guifg=#d787ff
:highlight x178_Gold3                ctermfg=178 guifg=#d7af00
:highlight x179_LightGoldenrod3      ctermfg=179 guifg=#d7af5f
:highlight x180_Tan                  ctermfg=180 guifg=#d7af87
:highlight x181_MistyRose3           ctermfg=181 guifg=#d7afaf
:highlight x182_Thistle3             ctermfg=182 guifg=#d7afd7
:highlight x183_Plum2                ctermfg=183 guifg=#d7afff
:highlight x184_Yellow3              ctermfg=184 guifg=#d7d700
:highlight x185_Khaki3               ctermfg=185 guifg=#d7d75f
:highlight x186_LightGoldenrod2      ctermfg=186 guifg=#d7d787
:highlight x187_LightYellow3         ctermfg=187 guifg=#d7d7af
:highlight x188_Grey84               ctermfg=188 guifg=#d7d7d7
:highlight x189_LightSteelBlue1      ctermfg=189 guifg=#d7d7ff
:highlight x190_Yellow2              ctermfg=190 guifg=#d7ff00
:highlight x191_DarkOliveGreen1      ctermfg=191 guifg=#d7ff5f
:highlight x192_DarkOliveGreen1      ctermfg=192 guifg=#d7ff87
:highlight x193_DarkSeaGreen1        ctermfg=193 guifg=#d7ffaf
:highlight x194_Honeydew2            ctermfg=194 guifg=#d7ffd7
:highlight x195_LightCyan1           ctermfg=195 guifg=#d7ffff
:highlight x196_Red1                 ctermfg=196 guifg=#ff0000
:highlight x197_DeepPink2            ctermfg=197 guifg=#ff005f
:highlight x198_DeepPink1            ctermfg=198 guifg=#ff0087
:highlight x199_DeepPink1            ctermfg=199 guifg=#ff00af
:highlight x200_Magenta2             ctermfg=200 guifg=#ff00d7
:highlight x201_Magenta1             ctermfg=201 guifg=#ff00ff
:highlight x202_OrangeRed1           ctermfg=202 guifg=#ff5f00
:highlight x203_IndianRed1           ctermfg=203 guifg=#ff5f5f
:highlight x204_IndianRed1           ctermfg=204 guifg=#ff5f87
:highlight x205_HotPink              ctermfg=205 guifg=#ff5faf
:highlight x206_HotPink              ctermfg=206 guifg=#ff5fd7
:highlight x207_MediumOrchid1        ctermfg=207 guifg=#ff5fff
:highlight x208_DarkOrange           ctermfg=208 guifg=#ff8700
:highlight x209_Salmon1              ctermfg=209 guifg=#ff875f
:highlight x210_LightCoral           ctermfg=210 guifg=#ff8787
:highlight x211_PaleVioletRed1       ctermfg=211 guifg=#ff87af
:highlight x212_Orchid2              ctermfg=212 guifg=#ff87d7
:highlight x213_Orchid1              ctermfg=213 guifg=#ff87ff
:highlight x214_Orange1              ctermfg=214 guifg=#ffaf00
:highlight x215_SandyBrown           ctermfg=215 guifg=#ffaf5f
:highlight x216_LightSalmon1         ctermfg=216 guifg=#ffaf87
:highlight x217_LightPink1           ctermfg=217 guifg=#ffafaf
:highlight x218_Pink1                ctermfg=218 guifg=#ffafd7
:highlight x219_Plum1                ctermfg=219 guifg=#ffafff
:highlight x220_Gold1                ctermfg=220 guifg=#ffd700
:highlight x221_LightGoldenrod2      ctermfg=221 guifg=#ffd75f
:highlight x222_LightGoldenrod2      ctermfg=222 guifg=#ffd787
:highlight x223_NavajoWhite1         ctermfg=223 guifg=#ffd7af
:highlight x224_MistyRose1           ctermfg=224 guifg=#ffd7d7
:highlight x225_Thistle1             ctermfg=225 guifg=#ffd7ff
:highlight x226_Yellow1              ctermfg=226 guifg=#ffff00
:highlight x227_LightGoldenrod1      ctermfg=227 guifg=#ffff5f
:highlight x228_Khaki1               ctermfg=228 guifg=#ffff87
:highlight x229_Wheat1               ctermfg=229 guifg=#ffffaf
:highlight x230_Cornsilk1            ctermfg=230 guifg=#ffffd7
:highlight x231_Grey100              ctermfg=231 guifg=#ffffff
:highlight x232_Grey3                ctermfg=232 guifg=#080808
:highlight x233_Grey7                ctermfg=233 guifg=#121212
:highlight x234_Grey11               ctermfg=234 guifg=#1c1c1c
:highlight x235_Grey15               ctermfg=235 guifg=#262626
:highlight x236_Grey19               ctermfg=236 guifg=#303030
:highlight x237_Grey23               ctermfg=237 guifg=#3a3a3a
:highlight x238_Grey27               ctermfg=238 guifg=#444444
:highlight x239_Grey30               ctermfg=239 guifg=#4e4e4e
:highlight x240_Grey35               ctermfg=240 guifg=#585858
:highlight x241_Grey39               ctermfg=241 guifg=#626262
:highlight x242_Grey42               ctermfg=242 guifg=#6c6c6c
:highlight x243_Grey46               ctermfg=243 guifg=#767676
:highlight x244_Grey50               ctermfg=244 guifg=#808080
:highlight x245_Grey54               ctermfg=245 guifg=#8a8a8a
:highlight x246_Grey58               ctermfg=246 guifg=#949494
:highlight x247_Grey62               ctermfg=247 guifg=#9e9e9e
:highlight x248_Grey66               ctermfg=248 guifg=#a8a8a8
:highlight x249_Grey70               ctermfg=249 guifg=#b2b2b2
:highlight x250_Grey74               ctermfg=250 guifg=#bcbcbc
:highlight x251_Grey78               ctermfg=251 guifg=#c6c6c6
:highlight x252_Grey82               ctermfg=252 guifg=#d0d0d0
:highlight x253_Grey85               ctermfg=253 guifg=#dadada
:highlight x254_Grey89               ctermfg=254 guifg=#e4e4e4
:highlight x255_Grey93               ctermfg=255 guifg=#eeeeee
" }}}









