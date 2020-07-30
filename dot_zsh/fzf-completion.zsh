
# # disable sort when completing options of any command
# zstyle ':completion:complete:*:options' sort true

# # # use input as query string when completing zlua
# # zstyle ':fzf-tab:complete:_zlua:*' query-string input

# # (experimental, may change in the future)
# # some boilerplate code to define the variable `extract` which will be used later
# # please remember to copy them
# # local extract="
# # # trim input(what you select)
# # local in=\${\${\"\$(<{f})\"%\$'\0'*}#*\$'\0'}
# # # get ctxt for current completion(some thing before or after the current word)
# # local -A ctxt=(\"\${(@ps:\2:)CTXT}\")
# # # real path
# # local realpath=\${ctxt[IPREFIX]}\${ctxt[hpre]}\$in
# # realpath=\${(Qe)~realpath}
# # "

# # give a preview of commandline arguments when completing `kill`
# zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
# zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap

# # give a preview of directory by exa when completing cd
# zstyle ':fzf-tab:complete:cd:*' extra-opts --preview=$extract'exa -1 --color=always $realpath'

# # FZF_TAB_COMMAND=(
# #     fzf
# #     --ansi   # Enable ANSI color support, necessary for showing groups
# #     --expect='$continuous_trigger,$print_query' # For continuous completion and print query
# #     '--color=hl:$(( $#headers == 0 ? 108 : 255 ))'
# #     --nth=2,3 --delimiter='\x00'  # Don't search prefix
# #     --layout=reverse --height='${FZF_TMUX_HEIGHT:=75%}'
# #     --tiebreak=begin -m --bind=tab:down,btab:up,change:top,ctrl-space:toggle --cycle
# #     '--query=$query'   # $query will be expanded to query string at runtime.
# #     '--header-lines=$#headers' # $#headers will be expanded to lines of headers at runtime
# #     --print-query
# # )
# zstyle ':fzf-tab:*' command $FZF_TAB_COMMAND

# # The key to trigger a continuous completion. It's useful when complete a long path.
# zstyle ':fzf-tab:*' continuous-trigger '/'

# # Press this key to use current user input as final completion result.
# zstyle: ':fzf-tab:*' print-query alt-enter

# # Don't activate fzf-tab in this context. If it is a number, then fzf-tab won't be activated if the number of candidates is smaller than this number.
# zstyle ':fzf-tab:*' ignore false

# zstyle ':fzf-tab:*' fake-compadd default

# zstyle ':fzf-tab:*' insert-space true

# zstyle ':fzf-tab:*' query-string prefix input first