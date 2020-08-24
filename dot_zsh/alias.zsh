alias zshreload='source ~/.zshrc'             # reload ZSH
alias c='clear'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Stats
alias shtop='sudo htop'                       # run `htop` with root rights 
alias meminfo='free -m -l -t'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
alias cpuinfo='lscpu'
alias ping='ping -c 5'
alias speed='speedtest-cli --single'
alias ipe='curl ipinfo.io/ip'
alias ports='netstat -tulanp'


# Program overrides and shortcuts
alias vim='nvim'
alias vi='nvim'
alias oldvim='\vim'
alias oldvi='\vi'
alias e="$EDITOR"
alias v="$VISUAL"
alias f="ranger"
alias df='df -H'
alias du='du -ch'
alias oldcat="\cat"
alias cat="bat"

# files
alias less='less -R'
alias grep='grep --color=auto'                # colorize `grep` output
alias lsnotes='rg -e "(TODO|FIXME|OPTIMIZE|REVIEW)"'
alias lsfiles='colorls -a | rg ^-'
alias lsdirs='colorls -a | rg ^d'
alias ls='colorls --group-directories-first'
alias lc='colorls -laht --group-directories-first'
alias la= 'colorls -a --group-directories-first'
alias -s {yml,yaml}=vim
alias untar='tar -zxvf '
alias wget='wget -c '
alias g='git'

alias getpass="openssl rand -base64 28"
alias sha='shasum -a 256 '
alias bc='bc -l'

# Add safety nets
# do not delete / or prompt if deleting more than 3 files at a time #
alias rm='rm -I --preserve-root'
 
# confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

# Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Tmux
alias t='tmux'
alias mux="tmuxinator"
alias tx='tmuxinator'
alias txstart='tmuxinator start $(tmuxinator list -n | tail -n +2 | fzf)'
alias txstop='tmuxinator stop $(tmuxinator list -n | tail -n +2 | fzf)'
alias tatt='tmux attach -t $(tmux ls | fzf -1 | cut -d: -f1)'

# useful
alias cal='gcal --starting-day=1'   
alias weather='curl v2.wttr.in'  
alias weathert='curl v2.wttr.in/"Torroella de Montgri, Spain"'
alias weatherbonn='curl v2.wttr.in/"Bonn, Germany"'
alias weatherbcn='curl v2.wttr.in/"Barcelona, Spain"'

# npm
alias n='npm'
# install
alias ni='npm install'
alias nis='npm install --save'
alias nid='npm install --save-dev'
alias nig='npm install --global'
# uninstall
alias nu='npm uninstall'
alias nus='npm uninstall --save'
alias nud='npm uninstall --save-dev'
alias nug='npm uninstall --global'
# misc
alias nt='npm test'
alias nk='npm link'
alias nr='npm run'
alias nf='npm cache clean && rm -rf node_modules && npm install'

# yarn
alias y='yarn'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yr='yarn run'
alias yR='yarn remove'
alias yt='yarn test'
alias yu='yarn upgrade'
alias yui='yarn upgrade-interactive'

# https://github.com/ogham/exa
alias l="exa -lbha --git --group-directories-first"
alias ll="exa -lbhaT"
alias l1="exa -lbhaT -L 1"
alias l2="exa -lbhaT -L 2"
alias l3="exa -lbhaT -L 3"
