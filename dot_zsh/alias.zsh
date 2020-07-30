alias zshreload='source ~/.zshrc'             # reload ZSH
alias shtop='sudo htop'                       # run `htop` with root rights
alias grep='grep --color=auto'                # colorize `grep` output
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias less='less -R'
alias g='git'
alias cal='gcal --starting-day=1'   
alias weather='curl v2.wttr.in'  
alias vim='nvim'

# files listing
alias lsnotes='rg -e "(TODO|FIXME|OPTIMIZE|REVIEW)"'
alias lsfiles='la | rg ^-'
alias lsdirs='la | rg ^d'
alias ls='colorls --group-directories-first'


# Tmux
alias t='tmux'
alias tx='tmuxinator'
alias txstart='tmuxinator start $(tmuxinator list -n | tail -n +2 | fzf)'
alias txstop='tmuxinator stop $(tmuxinator list -n | tail -n +2 | fzf)'
alias tatt='tmux attach -t $(tmux ls | fzf -1 | cut -d: -f1)'