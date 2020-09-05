"
syn on
set nobackup
set nowritebackup
"try setting undodir, this will enable undo even after reopen
set noundofile
se nu
set tabstop=2
set shiftwidth=2
"set expandtab
set ignorecase
"allows to switch buffer if the current buffer is not saved
set hidden
"avoid linebreaks while wrap
set textwidth=0
"set dir=~/.vimswapfiles

if has("gui_running")
  "set guifont=Courier\ 11\ Pitch\ 10
  set guifont=Cascadia_Code_SemiLight:h10:W350:cANSI:qDRAFT
  set lines=35 columns=125
  set guioptions-=T
  "colorscheme evening
endif

