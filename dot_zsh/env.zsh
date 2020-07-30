
###########
## Shell ##
###########
export EDITOR=nvim

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
