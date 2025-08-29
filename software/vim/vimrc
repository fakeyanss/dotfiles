" Plugin ---------- {{{
call plug#begin()
" vimdoc
Plug 'yianwillis/vimcdoc'
" zen mode
Plug 'junegunn/goyo.vim', { 'for': ['markdown', 'text', 'vim'] }
Plug 'junegunn/limelight.vim'
" yank
Plug 'ojroques/vim-oscyank', {'branch': 'main'}
Plug 'vim-scripts/YankRing.vim'
" input method
if !has('gui_running')
  Plug 'brglng/vim-im-select'
endif
" keybinding popup
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
" file tree
Plug 'preservim/nerdtree'
" surround
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
" theme
Plug 'nordtheme/vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" fuzzy search
" Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
" tags
" Plug 'ludovicchabant/vim-gutentags'
" comment stuff
Plug 'tpope/vim-commentary'
" markdown
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}
Plug 'SidOfc/mkdx'
" plantuml
Plug 'tyru/open-browser.vim'
Plug 'aklt/plantuml-syntax'
Plug 'weirongxu/plantuml-previewer.vim'

" Unmanaged plugin (manually installed and updated)
Plug '~/.vim/my-plugins'

call plug#end()
" }}}



" Basic ---------- {{{
set nocompatible

set history=1000            " 在命令行里输入的命令保存在历史记录中的数量
set ruler                   " 显示光标位置的行号和列号
set number                  " 在每行之前显示行号
set showcmd                 " 在屏幕最后一行显示命令
set showmode                " 在插入、替换和可视模式里，在最后一行提供消息
set laststatus=2            " 最后一个窗口何时有状态行，2 为总是
set cmdheight=1             " 命令行使用的屏幕行数
set scrolloff=4             " 光标上下两侧最少保留的屏幕行数，这使得工作时总有一些可见的上下文

" 以下三行关闭响铃，也关闭闪烁
set noerrorbells
set novisualbell
set t_vb=

" color theme
set termguicolors
colorscheme nord
set background=dark         " 暗色模式

syntax on                   " 打开语法高亮
set backspace=2             " 允许在自动缩进、换行符、插入开始位置上退格
set whichwrap+=<,>,h,l      " 使光标移动可以跨行

set expandtab               " 插入 <Tab> 时，自动替换为合适数量的空格
set smarttab                " 行首的 <Tab> 根据 'shiftwidth' 插入空白，<BS> 删除行首 'shiftwidth' 那么多的空白
set shiftwidth=4            " 缩进每一步使用的空白数目
set tabstop=4               " 文件里 <Tab> 代表的空格数
set softtabstop=0           "  关闭softtabstop 永远不要将空格和tab混合输入
set autoindent              " 自动缩进
set cindent                 " 打开自动 C 程序缩进

set nobackup                " 写入文件前不要备份
set noswapfile              " 不要交换文件
set nowritebackup           " 不用写入备份文件
set autoread                " 如果文件在别处修改过，Vim 中重新自动读入
set autowrite               " 切换缓冲区时，文件自动写入
set hidden                  " 允许把未保存的缓冲区切换到后台
set fileencodings=utf-8,cp936
set fileformats=unix,dos,mac
set viminfo='1000,f1,<500,:1000,@1000,/1000,h,r$TEMP:,s10,n~/.viminfo

" 以下几行设置和字符串模式匹配有关的选项
set showmatch
set matchtime=2
set hlsearch
set incsearch
set ignorecase
set smartcase
set infercase
set wildignorecase
set magic
set lazyredraw
set nowrapscan
set iskeyword+=_,$,@,%,#,-,.
set wildignore+=*.swp,*.pyc

" 以下几行设置补全的样式
set wildoptions=pum
set wildmode=full
set wildmenu
set completeopt=menu,menuone,noselect,noinsert

set previewpopup=height:20,width:80     " 把预览窗口配置为弹出窗口

set timeoutlen=250
" set small ttm to speed up InsertLeave event callback for im-select
set ttimeoutlen=10

set clipboard+=unnamed " 使用系统剪贴板

filetype plugin indent on

" }}}



" Pre-defined functions ---------- {{{

silent function! OSX()
  return has('macunix')
endfunction

silent function! LINUX()
  return has('unix') && !has('macunix') && !has('win32unix')
endfunction

silent function! WINDOWS()
  return (has('win32') || has('win64'))
endfunction

" }}}



" Basic Keybinding ---------- {{{

let mapleader=" "
" Cancel search highlight
map <BS><BS> :noh<CR> 

" Move to line start/end
map H ^
map L $
" Move between blocks
map J }
map K {

" Switch to normal mode
vmap i <Esc>
imap jk <Esc>

" Toggle wrap
nmap <leader>w :set wrap!<cr>

" Block ident
vmap < <gv
vmap > >gv

" Pane vertically split/horizontally split/close
map <leader>\ :vsplit<CR>
map <leader>- :split<CR>
" Move between panes top/bottom/left/right
map <C-k> <C-w>k
map <C-j> <C-w>j
map <C-h> <C-w>h
map <C-l> <C-w>l
map <C-q> <C-w>c
" Tab 
map gl :tabNext<CR>
map gh :tabprevious<CR>
"map <C-w> :tabclose<CR>

" delele to black hole clipboard, not cut
nnoremap <leader>d "_d xnoremap <leader>d "_d
"xnoremap <leader>p "_dP

" merge tab
nnoremap <leader>tm :call MoveToNextTab()<cr>
nnoremap <leader>tM :call MoveToPrevTab()<cr>
" }}}



" Plugin setting ---------- {{{

" junegunn/goyo.vim ---------- {{
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
let g:limelight_conceal_ctermfg = 'gray'

nnoremap <silent> <leader>z :Goyo<cr>

function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  set laststatus=0
  Limelight
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
  set laststatus=2
  Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
" }}

" brglng/vim-im-select ---------- {{
if OSX()
  let g:im_select_default = 'com.apple.keylayout.ABC'
elseif WINDOWS()
  let g:im_select_default = '1033'
endif
let g:im_select_switch_timeout = 50
" }}

" ojroques/vim-oscyank ---------- {{
nmap <leader>c <Plug>OSCYankOperator
nmap <leader>cc <leader>c_
vmap <leader>c <Plug>OSCYankVisual
" }}

" vim-scripts/YankRing.vim ---------- {{
let g:yankring_history_dir = '~/.vim'
map <leader>yr :YRToggle<CR>
" }}

" liuchengxu/vim-which-key ---------- {{
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
" }}

" preservim/nerdtree ---------- {{
augroup nerdtree_settings
    autocmd!
    " NERDDTree快捷键
	nnoremap <leader>n :NERDTreeToggle<CR>
    nnoremap <leader>d :NERDTreeFind<cr>
    " 是否显示隐藏文件
    let NERDTreeShowHidden=1
    " 设置宽度
    let NERDTreeWinSize=30
    " 在终端启动vim时，共享NERDTree
    let g:nerdtree_tabs_open_on_console_startup=1
    " 忽略以下文件的显示
    let NERDTreeIgnore=['\.pyc','\~$',
                \ '\.swp',
                \ '\.o',
                \ '.DS_Store',
                \ '\.orig$',
                \ '@neomake_',
                \ '.coverage.',
                \ '__pycache__$[[dir]]',
                \ 'debug_json$[[dir]]',
                \ 'debug$[[dir]]',
                \ '.pytest_cache$[[dir]]',
                \ '.git$[[dir]]',
                \ '.idea[[dir]]',
                \ '.vscode[[dir]]',
                \ 'htmlcov[[dir]]',
                \ 'test-reports[[dir]]',
                \ '.egg-info$[[dir]]']
    " 显示书签列表
    let NERDTreeShowBookmarks=1
    " 改变nerdtree的箭头
    " let g:NERDTreeDirArrowExpandable = '?'
    " let g:NERDTreeDirArrowCollapsible = '?'
    " vim不指定具体文件打开时，自动使用nerdtree
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree |endif

    " 当vim打开一个目录时，nerdtree自动使用
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
    " 打开新的窗口，focus在buffer里而不是NerdTree里
    autocmd VimEnter * :wincmd l

    " 当vim中没有其他文件，值剩下nerdtree的时候，自动关闭窗口
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

augroup END
" }}

" " ludovicchabant/vim-gutentags ---------- {{
" " gutentags 搜索工程目录的标志，当前文件路径向上递归直到碰到这些文件/目录名
" let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
" " 所生成的数据文件的名称
" let g:gutentags_ctags_tagfile = '.tags'
" " 同时开启 ctags 和 gtags 支持：
" let g:gutentags_modules = []
" if executable('ctags')
" 	let g:gutentags_modules += ['ctags']
" endif
" if executable('gtags-cscope') && executable('gtags')
" 	let g:gutentags_modules += ['gtags_cscope']
" endif
" " 将自动生成的 ctags/gtags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
" let s:vim_tags = expand('~/.cache/tags')
" let g:gutentags_cache_dir = s:vim_tags
" if !isdirectory(s:vim_tags)
"     silent! call mkdir(s:vim_tags)
" endif

" " 配置 ctags 的参数，老的 Exuberant-ctags 不能有 --extra=+q，注意
" let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
" let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
" let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" " 如果使用 universal ctags 需要增加下面一行，老的 Exuberant-ctags 不能加下一行
" let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

" " 禁用 gutentags 自动加载 gtags 数据库的行为
" let g:gutentags_auto_add_gtags_cscope = 0
" " }}

" Yggdroot/LeaderF ---------- {{
"if OSX()
"    let s:cachedir = expand('~/.cache/vim')
"elseif WINDOWS()
"    let s:cachedir = expand('~/AppData/Local/Temp/cache/vim')
"endif
"let g:Lf_WorkingDirectoryMode = 'AF'
"let g:Lf_RootMarkers = ['.git', '.svn', '.hg', '.project', '.root']
"let g:Lf_UseVersionControlTool=1 "default value, can ignore
"let g:Lf_DefaultExternalTool='rg'
"let g:Lf_PreviewInPopup = 1
"let g:Lf_WindowHeight = 0.30
"let g:Lf_CacheDirectory = s:cachedir
""let g:Lf_StlColorscheme = 'powerline'
"let g:Lf_PreviewResult = {
"        \ 'File': 0,
"        \ 'Buffer': 0,
"        \ 'Mru': 0,
"        \ 'Tag': 0,
"        \ 'BufTag': 1,
"        \ 'Function': 1,
"        \ 'Line': 1,
"        \ 'Colorscheme': 0,
"        \ 'Rg': 0,
"        \ 'Gtags': 0
"        \}
"let g:Lf_GtagsAutoGenerate = 0
"let g:Lf_GtagsGutentags = 1
"let g:Lf_ShortcutF = '<leader>p'
"let g:Lf_ShortcutB = '<leader>l'
""noremap <leader>f :LeaderfSelf<cr>
"noremap <leader>fm :LeaderfMru<cr>
"noremap <leader>ff :LeaderfFunction<cr>
"noremap <leader>fb :LeaderfBuffer<cr>
"noremap <leader>ft :LeaderfBufTag<cr>
"noremap <leader>fl :LeaderfLine<cr>
"noremap <leader>fw :LeaderfWindow<cr>
"noremap <leader>frr :LeaderfRgRecall<cr>

"nmap <unique> <leader>fr <Plug>LeaderfRgPrompt
"nmap <unique> <leader>fra <Plug>LeaderfRgCwordLiteralNoBoundary
"nmap <unique> <leader>frb <Plug>LeaderfRgCwordLiteralBoundary
"nmap <unique> <leader>frc <Plug>LeaderfRgCwordRegexNoBoundary
"nmap <unique> <leader>frd <Plug>LeaderfRgCwordRegexBoundary

"vmap <unique> <leader>fra <Plug>LeaderfRgVisualLiteralNoBoundary
"vmap <unique> <leader>frb <Plug>LeaderfRgVisualLiteralBoundary
"vmap <unique> <leader>frc <Plug>LeaderfRgVisualRegexNoBoundary
"vmap <unique> <leader>frd <Plug>LeaderfRgVisualRegexBoundary

"nmap <unique> <leader>fgd <Plug>LeaderfGtagsDefinition
"nmap <unique> <leader>fgr <Plug>LeaderfGtagsReference
"nmap <unique> <leader>fgs <Plug>LeaderfGtagsSymbol
"nmap <unique> <leader>fgg <Plug>LeaderfGtagsGrep

"vmap <unique> <leader>fgd <Plug>LeaderfGtagsDefinition
"vmap <unique> <leader>fgr <Plug>LeaderfGtagsReference
"vmap <unique> <leader>fgs <Plug>LeaderfGtagsSymbol
"vmap <unique> <leader>fgg <Plug>LeaderfGtagsGrep

"noremap <leader>fgo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
"noremap <leader>fgn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
"noremap <leader>fgp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
" }}

" instant-markdown/vim-instant-markdown ---------- {{
let g:instant_markdown_autostart = 0
let g:instant_markdown_mermaid = 1
map <leader>imp :InstantMarkdownPreview<CR>
map <leader>ims :InstantMarkdownStop<CR>
" }}

" SidOfc/mkdx ---------- {{
let g:mkdx#settings = { 'map': { 'enable': 0 } }
let g:mkdx#settings = { 'toc': { 'update_on_write': 0 } }
" nnoremap <leader>mt <Plug>(mkdx-quickfix-toc)
nnoremap <leader>mt <Plug>(mkdx-gen-or-upd-toc)
" }}

" }}}


" My Functions ---------- {{{

" 将当前window合并到前一个tab
function! MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    sp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

" 将当前window合并到后一个tab
function! MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    sp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

" }}}

" My autocmd ---------- {{{

" Automatically paste mode ---------- {{
" If Vim is inside of a Tmux session then double escape is required.
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

" automatically set/unset Vim’s ‘paste’ mode
let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
" }}

" Markdown
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.mdx set filetype=markdown
"augroup InstantMarkdownGroup
"    au! BufRead,BufNewFile,BufEnter ~/src/someproject/*.md let g:instant_markdown_autostart=1
"augroup END

"}}}
