if exists("g:loaded_codeium")
  finish
endif
let g:loaded_codeium = 1

function! s:SetStyle() abort
  if &t_Co == 256
    hi def CodeiumSuggestion guifg=#808080 ctermfg=244
  else
    hi def CodeiumSuggestion guifg=#808080 ctermfg=8
  endif
  hi def link CodeiumAnnotation Normal
endfunction

function! s:MapTab() abort
  imap <script><silent><nowait><expr> <Tab> codeium#Accept()
endfunction

augroup codeium
  autocmd!
  autocmd InsertEnter,CursorMovedI,CompleteChanged * call codeium#DebouncedComplete()
  autocmd BufEnter     * if mode() =~# '^[iR]'|call codeium#DebouncedComplete()|endif
  autocmd InsertLeave  * call codeium#Clear()
  autocmd BufLeave     * if mode() =~# '^[iR]'|call codeium#Clear()|endif

  autocmd ColorScheme,VimEnter * call s:SetStyle()
  " Map tab using vim enter so it occurs after all other sourcing.
  autocmd VimEnter             * call s:MapTab()
augroup END

imap <Plug>(codeium-dismiss)     <Cmd>call codeium#Clear()<CR>
if empty(mapcheck('<C-]>', 'i'))
  imap <silent><script><nowait><expr> <C-]> codeium#Clear() . "\<C-]>"
endif
imap <Plug>(codeium-next)     <Cmd>call codeium#CycleCompletions(1)<CR>
imap <Plug>(codeium-previous) <Cmd>call codeium#CycleCompletions(-1)<CR>
imap <Plug>(codeium-complete)  <Cmd>call codeium#Complete<CR>
if empty(mapcheck('<M-]>', 'i'))
  imap <M-]> <Plug>(codeium-next)
endif
if empty(mapcheck('<M-[>', 'i'))
  imap <M-[> <Plug>(codeium-previous)
endif
if empty(mapcheck('<M-Bslash>', 'i'))
  imap <M-Bslash> <Plug>(codeium-complete)
endif
