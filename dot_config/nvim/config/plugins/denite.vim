" :h denite.txt
" ---
" Problems? https://github.com/Shougo/denite.nvim/issues

" Don't reload Denite twice (on vimrc reload)
if exists('*denite#start')
	finish
endif

" Denite general settings
call denite#custom#option('_', {
	\ 'prompt': '❯',
	\ 'start_filter': v:true,
	\ 'smartcase': v:true,
	\ 'vertical_preview': v:true,
	\ 'source_names': 'short',
	\ 'max_dynamic_update_candidates': 50000,
	\ })

" Use Neovim's floating window
if has('nvim-0.4')
	call denite#custom#option('_', {
		\ 'highlight_filter_background': 'NormalFloat',
		\ 'split': 'floating',
		\ 'filter_split_direction': 'floating',
		\ 'floating_preview': v:true,
		\ })
endif

" Interactive grep search
call denite#custom#var('grep', 'min_interactive_pattern', 2)
call denite#custom#source('grep', 'args', ['', '', '!'])

" Allow customizable window positions: top, bottom, center (default)
function! s:denite_resize(position)
	if a:position ==# 'top'
		call denite#custom#option('_', {
			\ 'winwidth': (&columns - (&columns / 3)) - 1,
			\ 'winheight': &lines / 3,
			\ 'wincol': 0,
			\ 'winrow': 1,
			\ })
	elseif a:position ==# 'bottom'
		call denite#custom#option('_', {
			\ 'winwidth': (&columns - (&columns / 3)) - 1,
			\ 'winheight': &lines / 3,
			\ 'wincol': 0,
			\ 'winrow': (&lines - 2) - (&lines / 3),
			\ })
	else
		" Use Denite default, which is centered.
	endif
endfunction

" Set Denite's window position
let g:denite_position = get(g:, 'denite_position', '')
call s:denite_resize(g:denite_position)

" MATCHERS
" Default is 'matcher/fuzzy'
call denite#custom#source('tag', 'matchers', ['matcher/substring'])
call denite#custom#source('file/old', 'matchers', [
	\ 'matcher/project_files', 'matcher/ignore_globs' ])

" Use vim-clap's rust binary, called maple
if dein#tap('vim-clap')
	call denite#custom#filter('matcher/clap', 'clap_path',
		\ dein#get('vim-clap')['path'])

	call denite#custom#source('file/rec', 'matchers', [ 'matcher/clap' ])
endif

" SORTERS
" Default is 'sorter/rank'
call denite#custom#source('z', 'sorters', ['sorter_z'])

" CONVERTERS
" Default is none
call denite#custom#source(
	\ 'buffer,file_mru,file/old',
	\ 'converters', ['converter_relative_word'])

" FIND and GREP COMMANDS
" ---
" Ripgrep
if executable('rg')
	call denite#custom#var('file/rec', 'command',
		\ ['rg', '--hidden', '--files', '--glob', '!.git', '--color', 'never'])

	call denite#custom#var('grep', {
		\ 'command': ['rg'],
		\ 'default_opts': ['--hidden', '-i', '--vimgrep', '--no-heading'],
		\ 'recursive_opts': [],
		\ 'pattern_opt': ['--regexp'],
		\ })

" The Silver Searcher (ag)
elseif executable('ag')
	call denite#custom#var('file/rec', 'command',
		\ ['ag', '--hidden', '--follow', '--nocolor', '--nogroup', '-g', ''])

	" Setup ignore patterns in your .agignore file!
	" https://github.com/ggreer/the_silver_searcher/wiki/Advanced-Usage
	call denite#custom#var('grep', {
		\ 'command': ['ag'],
		\ 'default_opts': ['--vimgrep', '-i', '--hidden'],
		\ 'recursive_opts': [],
		\ 'pattern_opt': [],
		\ })

" Ack command
elseif executable('ack')
	call denite#custom#var('grep', {
		\ 'command': ['ack'],
		\ 'default_opts': [
		\   '--ackrc', $HOME.'/.config/ackrc', '-H', '-i',
		\   '--nopager', '--nocolor', '--nogroup', '--column',
		\ ],
		\ 'recursive_opts': [],
		\ 'pattern_opt': ['--match'],
		\ })
endif

" Denite EVENTS
augroup user_plugin_denite
	autocmd!

	autocmd FileType denite call s:denite_settings()
	autocmd FileType denite-filter call s:denite_filter_settings()
	autocmd User denite-preview call s:denite_preview()

	autocmd VimResized * call s:denite_resize(g:denite_position)

	" Enable Denite special cursor-line highlight
	autocmd WinEnter * if &filetype =~# '^denite'
		\ |   highlight! link CursorLine WildMenu
		\ | endif

	" Disable Denite special cursor-line highlight
	autocmd WinLeave * if &filetype ==# 'denite'
		\ |   highlight! link CursorLine NONE
		\ | endif
augroup END

" Denite main window settings
function! s:denite_settings() abort
	" Window options
	setlocal signcolumn=no cursorline

	" Denite selection window key mappings
	nmap <silent><buffer> <C-j> j
	nmap <silent><buffer> <C-k> k
	nmap <silent><buffer> <C-n> j
	nmap <silent><buffer> <C-p> k
	nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
	nnoremap <silent><buffer><expr> i    denite#do_map('open_filter_buffer')
	nnoremap <silent><buffer><expr> /    denite#do_map('open_filter_buffer')
	nnoremap <silent><buffer><expr> dd   denite#do_map('do_action', 'delete')
	nnoremap <silent><buffer><expr> p    denite#do_map('do_action', 'preview')
	nnoremap <silent><buffer><expr> st   denite#do_map('do_action', 'tabopen')
	nnoremap <silent><buffer><expr> sg   denite#do_map('do_action', 'vsplit')
	nnoremap <silent><buffer><expr> sv   denite#do_map('do_action', 'split')
	nnoremap <silent><buffer><expr> '    denite#do_map('quick_move')
	nnoremap <silent><buffer><expr> q    denite#do_map('quit')
	nnoremap <silent><buffer><expr> r    denite#do_map('redraw')
	nnoremap <silent><buffer><expr> yy   denite#do_map('do_action', 'yank')
	nnoremap <silent><buffer><expr> <Esc>   denite#do_map('quit')
	nnoremap <silent><buffer><expr> <Tab>   denite#do_map('choose_action')
	nnoremap <silent><buffer><expr><nowait> <Space> denite#do_map('toggle_select').'j'
endfunction

" Denite-preview window settings
function! s:denite_preview() abort
	" Window options
	setlocal nocursorline colorcolumn= signcolumn=no nonumber nolist nospell

	if &lines > 35
		resize +8
	endif
	" let l:pos = win_screenpos(win_getid())
	" let l:heighten = &lines - l:pos[0]
	" execute 'resize ' . l:heighten

	" Clear indents
	if exists('*indent_guides#clear_matches')
		call indent_guides#clear_matches()
	endif
endfunction

" Denite-filter window settings
function! s:denite_filter_settings() abort
	" Window options
	setlocal signcolumn=yes nocursorline nonumber norelativenumber

	" Disable Deoplete auto-completion within Denite filter window
	if exists('*deoplete#custom#buffer_option')
		call deoplete#custom#buffer_option('auto_complete', v:false)
	endif

	" Denite Filter window key mappings
	imap <silent><buffer> jj          <Plug>(denite_filter_quit)
	nmap <silent><buffer> <Esc>       <Plug>(denite_filter_quit)
	imap <silent><buffer> <Esc>       <Plug>(denite_filter_quit)
	nmap <silent><buffer> <C-c>       <Plug>(denite_filter_quit)
	imap <silent><buffer> <C-c>       <Plug>(denite_filter_quit)
	imap <silent><buffer> <C-p>       <Up>
	imap <silent><buffer> <C-n>       <Down>

	imap <silent><buffer> <Tab>   <Plug>(denite_filter_quit)ji
	imap <silent><buffer> <S-Tab> <Plug>(denite_filter_quit)ki
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
