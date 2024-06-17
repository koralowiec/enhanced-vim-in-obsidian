" Yank to system clipboard
set clipboard=unnamedplus

" Change tabs
exmap prevtab obcommand workspace:previous-tab
nmap gT :prevtab
nmap J :prevtab
exmap nexttab obcommand workspace:next-tab
nmap gt :nexttab
nmap K :nexttab

" Navigate: go back/forward
exmap goback obcommand app:go-back
nmap <A-h> :goback
exmap goforward obcommand app:go-forward
nmap <A-l> :goforward

" Close
exmap close obcommand workspace:close
exmap save obcommand editor:save-file
nmap ZZ :close | :save

" Open file explorer
exmap fileexplorer obcommand file-explorer:open
nmap ff :fileexplorer

" Follow link
exmap followlink obcommand editor:follow-link
nmap gd :followlink
exmap followlinknewtab obcommand editor:open-link-in-new-leaf
nmap gD :followlinknewtab
exmap followlinknewsplit obcommand editor:open-link-in-new-split
nmap gS :followlinknewsplit

" Open new tab
exmap newtab obcommand workspace:new-tab
nmap t :newtab
