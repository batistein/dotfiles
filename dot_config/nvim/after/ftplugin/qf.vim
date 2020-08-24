" Extend romainl/vim-qf
" ---
" See: https://github.com/romainl/vim-qf

let s:save_cpo = &cpoptions
set cpoptions&vim

setlocal cursorline
if exists('&signcolumn')
	setlocal signcolumn=yes
endif

if ! exists('b:qf_isLoc')
	" Are we in a location list or a quickfix list?
	let b:qf_isLoc = ! empty(getloclist(0))
endif

let &l:statusline="%t%{exists('w:quickfix_title') ? ' '.w:quickfix_title : ''} %=%-15(%l,%L%V%) %P"

silent! nunmap <buffer> <CR>
silent! nunmap <buffer> p
silent! nunmap <buffer> q
silent! nunmap <buffer> s

nnoremap <silent><buffer> <CR>   :pclose!<CR><CR>:noautocmd wincmd b<CR>
nnoremap <silent><buffer> q      :pclose!<CR>:quit<CR>
nnoremap <silent><buffer> p      :call <SID>preview_file()<CR>
nnoremap <silent><buffer> K      :echo getline(line('.'))<CR>
nnoremap <silent><buffer> dd     :<C-u>Reject<CR>
nnoremap <silent><buffer> <C-r>  :<C-u>Restore<CR>
nnoremap <silent><buffer> R      :<C-u>Restore<CR>

nnoremap <buffer> O      :<C-u>ListLists<CR>
nnoremap <buffer> <C-s>  :<C-u>SaveList<Space>
nnoremap <buffer> S      :<C-u>SaveList<Space>
nnoremap <buffer> <C-o>  :<C-u>LoadList<Space>
nnoremap <buffer> i      :<C-u>Keep<Space>

if b:qf_isLoc == 1
	nnoremap <silent><buffer> o :pclose!<CR><CR>:lclose<CR>
else
	nnoremap <silent><buffer> o :pclose!<CR><CR>:cclose<CR>
endif

nnoremap <silent><buffer> sg :pclose!<CR><C-w><CR>:noautocmd wincmd b<CR>
nnoremap <silent><buffer> sv :pclose!<CR><C-w><CR><C-w>L:noautocmd wincmd b<CR>
nnoremap <silent><buffer> st :pclose!<CR><C-w><CR><C-w>T

nmap <buffer> <Tab>    <Plug>(qf_newer)
nmap <buffer> <S-Tab>  <Plug>(qf_older)
nmap <buffer> gj       <Plug>(qf_next_file)
nmap <buffer> gk       <Plug>(qf_previous_file)

" let s:ns = nvim_create_namespace('hlgrep')

if exists('b:undo_ftplugin')
	let b:undo_ftplugin .= ' | '
else
	let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= "execute 'nunmap <buffer> <CR>'"
	\ . " | execute 'nunmap <buffer> q'"
	\ . " | execute 'nunmap <buffer> p'"
	\ . " | execute 'nunmap <buffer> K'"
	\ . " | execute 'nunmap <buffer> <C-r>'"
	\ . " | execute 'nunmap <buffer> R'"
	\ . " | execute 'nunmap <buffer> O'"
	\ . " | execute 'nunmap <buffer> <C-s>'"
	\ . " | execute 'nunmap <buffer> S'"
	\ . " | execute 'nunmap <buffer> <C-o>'"
	\ . " | execute 'nunmap <buffer> i'"
	\ . " | execute 'nunmap <buffer> o'"
	\ . " | execute 'nunmap <buffer> sg'"
	\ . " | execute 'nunmap <buffer> sv'"
	\ . " | execute 'nunmap <buffer> st'"
	\ . " | execute 'nunmap <buffer> <Tab>'"
	\ . " | execute 'nunmap <buffer> <S-Tab>'"
	\ . " | execute 'nunmap <buffer> gj'"
	\ . " | execute 'nunmap <buffer> gk'"

function! s:preview_file()
	" Find the file, line number and column of current entry
	let l:raw = getline(line('.'))
	let l:file = fnameescape(substitute(l:raw, '|.*$', '', ''))
	let l:pos = substitute(l:raw, '^.\{-}|\(.\{-}|\).*$', '\1', '')
	let l:line = 1
	let l:column = 1
	if l:pos =~# '^\d\+'
		let l:line  = substitute(l:pos, '^\(\d\+\).*$', '\1', '')
		if l:pos =~# ' col \d\+|'
			let l:column = substitute(l:pos, '^\d\+ col \(\d\+\).*$', '\1', '')
		endif
	endif
	call preview#open(l:file, l:line, l:column)
endfunction

let &cpoptions = s:save_cpo
