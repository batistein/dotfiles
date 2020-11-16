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
- [hub](https://hub.github.com/) 

##  For using Oath not implemented yet
- oathtool
- gnupg2
- xclip

# Install 

```
chezmoi add https://github.com/batistein/dotfiles.git
chezmoi apply

## Path:
~/.local/share/chezmoi

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
- CTRL+T toggle fzf-tab on/off

### Install alacritty

https://github.com/alacritty/alacritty/blob/master/INSTALL.md


```
git clone https://github.com/alacritty/alacritty.git
cd alacritty
git checkout <branch - release name>
cargo build --release
```

#### Terminfo

To make sure Alacritty works correctly, either the `alacritty` or
`alacritty-direct` terminfo must be used. The `alacritty` terminfo will be
picked up automatically if it is installed.

If the following command returns without any errors, the `alacritty` terminfo is
already installed:

```sh
infocmp alacritty
```

If it is not present already, you can install it globally with the following
command:

```
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
```

#### Desktop Entry

Many Linux and BSD distributions support desktop entries for adding applications
to system menus. This will install the desktop entry for Alacritty:

```sh
sudo cp target/release/alacritty /usr/local/bin 
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
```

If you are having problems with Alacritty's logo, you can replace it with
prerendered PNGs and simplified SVGs available in the `extra/logo/compat`
directory.

# Dotfiles

## Zsh
I use zsh as my shell and use antibody for plugins. Plugins for antigen are working.
Starship is used as prompt.

## Tmux
Tmux is used as Terminalmultiplexer and to achieve together with neovim a IDE-like experience. 

- vimux
- vim-tmux-navigator
- vim-tmux-runner
## Nvim
Is running with vim-plug.
## fzf
Is a command-line fuzzy finder it improves my workflow a lot and could be used across vim, zsh, tmux. 



# TODO
Replace zsh's default completion selection menu with fzf!
https://github.com/Aloxaf/fzf-tab
