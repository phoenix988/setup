#!/bin/bash
##____  _                      _
#|  _ \| |__   ___   ___ _ __ (_)_  __
#| |_) | '_ \ / _ \ / _ \ '_ \| \ \/ /
#|  __/| | | | (_) |  __/ | | | |>  <
#|_|   |_| |_|\___/ \___|_| |_|_/_/\_\
#
# -*- coding: utf-8 -*-
# Script to quickly configure a new system with my configs
# Configure variables that I use in this script
DOTFILES_REPO_PATH="$HOME/dotfiles"
DMSCRIPTS_REPO_PATH="$HOME/dmscripts"

# imports the function to clone my wallpaper repo
source ../functions/wallpaper
source ../functions/main-config
source ../functions/install

# Will exit the script if git command doesn't exist
if command_exist git ; then

    printf ""
    clear

else

    printf '%s\n' "git is not installed"
    printf '%s\n' "Aborting....Please install git"
    exit

fi

# Clones my dotfiles repo
[ -d $DOTFILES_REPO_PATH ] || git clone https://github.com/phoenix988/dotfiles.git $DOTFILES_REPO_PATH

clear

# Clones my dmscripts repo
[ -d $DMSCRIPTS_REPO_PATH ] || git clone https://github.com/phoenix988/dmscripts.git $DMSCRIPTS_REPO_PATH

clear

# Clone my wallpapers
wallpaper

clear

# Declare the array with all my dotfiles
declare -A files


files[$HOME/.config/qtile]="$DOTFILES_REPO_PATH/.config/qtile"
files[$HOME/.config/nvim]="$DOTFILES_REPO_PATH/.config/nvim"
files[$HOME/.config/kitty]="$DOTFILES_REPO_PATH/.config/kitty"
files[$HOME/.config/bash]="$DOTFILES_REPO_PATH/.config/bash"
files[$HOME/.config/ncspot]="$DOTFILES_REPO_PATH/.config/ncspot"
files[$HOME/.config/fish]="$DOTFILES_REPO_PATH/.config/fish"
files[$HOME/.config/dunst]="$DOTFILES_REPO_PATH/.config/dunst"
files[$HOME/.config/rofi]="$DOTFILES_REPO_PATH/.config/rofi"
files[$HOME/.config/hypr]="$DOTFILES_REPO_PATH/.config/hypr"
files[$HOME/.config/waybar]="$DOTFILES_REPO_PATH/.config/waybar"
files[$HOME/.config/wofi]="$DOTFILES_REPO_PATH/.config/wofi"
files[$HOME/.config/wlogout]="$DOTFILES_REPO_PATH/.config/wlogout"
files[$HOME/.config/vifm]="$DOTFILES_REPO_PATH/.config/vifm"
files[$HOME/.config/starship.toml]="$DOTFILES_REPO_PATH/.config/starship.toml"
files[$HOME/.config/picom]="$DOTFILES_REPO_PATH/.config/picom"
files[$HOME/.config/conky]="$DOTFILES_REPO_PATH/.config/conky"
files[$HOME/.config/qutebrowser]="$DOTFILES_REPO_PATH/.config/qutebrowser"
files[$HOME/.config/sxiv]="$DOTFILES_REPO_PATH/.config/sxiv"
files[$HOME/.config/urxvt]="$DOTFILES_REPO_PATH/.config/urxvt"
files[$HOME/.config/alacritty]="$DOTFILES_REPO_PATH/.config/alacritty"
files[$HOME/.config/gtk-3.0]="$DOTFILES_REPO_PATH/.config/gtk-3.0"
files[$HOME/.config/oh-my-zsh/themes/nord.zsh-theme]="$DOTFILES_REPO_PATH/.config/oh-my-zsh/themes"
files[$HOME/.config/oh-my-zsh/aliases.sh]="$DOTFILES_REPO_PATH/.config/oh-my-zsh/aliases.sh"
files[$HOME/.zshrc]="$DOTFILES_REPO_PATH/.zshrc"
files[$HOME/.bashrc]="$DOTFILES_REPO_PATH/.bashrc"
files[$HOME/.fehbg]="$DOTFILES_REPO_PATH/.fehbg"
files[$HOME/.NERDTreeBookmarks]="$DOTFILES_REPO_PATH/.NERDTreeBookmarks"
files[$HOME/.gtkrc-2.0]="$DOTFILES_REPO_PATH/.gtkrc-2.0"
files[$HOME/.xmonad]="$DOTFILES_REPO_PATH/.xmonad"
files[$HOME/.spectrwm.conf]="$DOTFILES_REPO_PATH/.spectrwm.conf"
files[$HOME/.Xresources]="$DOTFILES_REPO_PATH/.Xresources"
files[$HOME/.tmux.conf.local]="$DOTFILES_REPO_PATH/.tmux.conf.local"
files[$HOME/.scripts]="$DOTFILES_REPO_PATH/.scripts"
files[$HOME/.dmenu]="$DMSCRIPTS_REPO_PATH/.dmenu"
files[$HOME/.config/dm-scripts.conf]="$DMSCRIPTS_REPO_PATH/.config/dm-script.conf"
files[$HOME/.config/alias-zsh-bash]="$DOTFILES_REPO_PATH/alias-zsh-bash"
files[$HOME/.local/share/applications]="$DOTFILES_REPO_PATH/.local/share/applications"


# Installs zsh if its needed
if command_exist apt ; then

command_exist zsh || printf '%s\n' "ZSH Not Installed: Installing"
command_exist zsh || sudo apt install -y zsh &> /dev/null


elif command_exist pacman ; then

command_exist zsh || printf '%s\n' "ZSH Not Installed: Installing"
command_exist zsh || sudo pacman -S --noconfirm zsh &> /dev/null


elif command_exist dnf ; then

command_exist zsh || printf '%s\n' "ZSH Not Installed: Installing"
command_exist zsh || sudo dnf install -y zsh &> /dev/null


fi

# If it failed to install zsh script will exit here
# Because otherwise oh my zsh will not be able to be installed
command_exist zsh || error "ZSH: Failed to Install"

# Installs oh-my-zsh framework
bash ./ohmyzsh.sh

# Installs the plugins I use
bash ./zsh-plugins.sh

clear

# Install starship prompt
sh ./starship.sh

clear

for FILES in $(printf '%s\n' "${!files[@]}") ; do


SOURCE_FILE=$(printf '%s\n' "${files["${FILES}"]}")

if [ -d $SOURCE_FILE ] ; then

[ -d $FILES ] || mkdir $FILES

cp -r $SOURCE_FILE/* $FILES 2> /dev/null
printf '%s\n' "Moving: $SOURCE_FILE to $FILES"

elif [ -f $SOURCE_FILE ] ; then

cp -r $SOURCE_FILE $FILES 2> /dev/null

fi


done

