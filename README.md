# Prerequisites

- [Chezmoi](https://github.com/twpayne/chezmoi/blob/master/docs/INSTALL.md)
- [Alacritty](https://github.com/alacritty/alacritty)
- ZSH
- [kubectx & kubens](https://github.com/ahmetb/kubectx/releases)
- [colorls](https://github.com/athityakumar/colorls)
- tmux
- kubectl
- docker-compose
- jq

##  For using Oath not implemented yet
- oathtool
- gnupg2
- xclip

# Install 

```
chezmoi add https://github.com/batistein/dotfiles.git
chezmoi apply

## Make ZSH as Defaul Shell 
chsh -s $(which zsh)
```

# Add on your machine a chezmoi.toml

```
# mkdir -p ~/.config/chezmoi && nano ~/.config/chezmoi/chezmoi.toml

[data]
  email = "john@home.org"
  name = "name"

```

# Change access rights
```
chmod 644 ~/.ssh/config
```

# FZF tab completion
https://github.com/Aloxaf/fzf-tab

- Tab for fuzzy
- Alt+Enter for exit - final completion result
- / for continous completion
- Alt+L or Arrow-Right accepts normal completion
- Alt+enter executes the autocompletion result

# TODO
Replace zsh's default completion selection menu with fzf!
https://github.com/Aloxaf/fzf-tab