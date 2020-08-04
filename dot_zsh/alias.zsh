alias zshreload='source ~/.zshrc'             # reload ZSH
alias shtop='sudo htop'                       # run `htop` with root rights
alias grep='grep --color=auto'                # colorize `grep` output
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias less='less -R'
alias g='git'
alias cal='gcal --starting-day=1'   
alias weather='curl v2.wttr.in'  
alias weathert='curl v2.wttr.in/"Torroella de Montgri, Spain"'
alias weatherbonn='curl v2.wttr.in/"Bonn, Germany"'
alias weatherbcn='curl v2.wttr.in/"Barcelona, Spain"'
alias vim='nvim'
alias vi='nvim'
alias e="$EDITOR"
alias v="$VISUAL"
alias df='df -H'
alias du='du -ch'
# files listing
alias lsnotes='rg -e "(TODO|FIXME|OPTIMIZE|REVIEW)"'
alias lsfiles='colorls -a | rg ^-'
alias lsdirs='colorls -a | rg ^d'
alias ls='colorls --group-directories-first'
alias lc='colorls -laht --group-directories-first'
alias la= 'colorls -a --group-directories-first'

# useful 
alias untar='tar -zxvf '
alias wget='wget -c '
alias getpass="openssl rand -base64 28"
alias sha='shasum -a 256 '
alias ping='ping -c 5'
alias speed='speedtest-cli --single'
alias ipe='curl ipinfo.io/ip'
alias c='clear'
alias bc='bc -l'
alias ports='netstat -tulanp'

# Add safety nets
# do not delete / or prompt if deleting more than 3 files at a time #
alias rm='rm -I --preserve-root'
 
# confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
 
## pass options to free ##
alias meminfo='free -m -l -t'
 
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
 
## Get server cpu info ##
alias cpuinfo='lscpu'

# Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Tmux
alias t='tmux'
alias tx='tmuxinator'
alias txstart='tmuxinator start $(tmuxinator list -n | tail -n +2 | fzf)'
alias txstop='tmuxinator stop $(tmuxinator list -n | tail -n +2 | fzf)'
alias tatt='tmux attach -t $(tmux ls | fzf -1 | cut -d: -f1)'
