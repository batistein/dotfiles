
###########
## Shell ##
###########
export EDITOR=nvim
export VISUAL=code

export STARSHIP_CONFIG=~/.zsh/starship.toml
export SPACESHIP_USER_SHOW="always"
export SPACESHIP_HOST_SHOW="always"

# Set your language environment
export LANG=en_US.UTF-8

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--layout=reverse --inline-info'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

###############
## Languages ##
###############

# Go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH


#############
## Plugins ##
#############
# Krew Kubectl Plugin Manager
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# configure zsh-autosuggestions
export FZF_DEFAULT_COMMAND="fd --one-file-system --type f --hidden . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --one-file-system --type d --hidden --exclude .git . $HOME"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=242,bg=grey,bold,underline"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion) 
export AUTO_NOTIFY_THRESHOLD=120
export AUTO_NOTIFY_EXPIRE_TIME=10000