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

# Add on your machine a ~/.config/chezmoi/chezmoi.toml
```
[data]
  email = "john@home.org"
  name = "name"

```


# TODO
Replace zsh's default completion selection menu with fzf!
https://github.com/Aloxaf/fzf-tab