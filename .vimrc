" Use vim settings, rather then vi settings (much better!)
" This must be first, because it changes other options as a side effect.
set nocompatible

" Use pathogen to easily modify the runtime path to include all plugins under
" the ~/.vim/bundle directory
filetype off                    " force reloading *after* pathogen loaded
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype plugin indent on       " enable detection, plugins and indenting in one step


