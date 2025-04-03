#!/bin/bash
############################
# This script automates dotfile setup and tool installation
# Thanks https://github.com/CoreyMSchafer/dotfiles/blob/master/install.sh
############################

set -e

echo ""
echo "+------------------------------------------------------------+"
echo "| This script automates dotfile setup and tool installation   |"
echo "|            Github: xiaozhu2007/dotfiles                     |"
echo "+------------------------------------------------------------+"
echo ""

if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root!" 1>&2
    exit 1
fi

# dotfiles directory
dotfiledir="~/dotfiles"

# =================
# Remove existing dotfiles directory
# =================
rm -r "${dotfiledir}"

# =================
# list of files/folders to symlink in ${dotfiledir}
# =================
files=(bashrc bash_profile bash_prompt aliases func profile)

# =================
# clone the repo
# =================
apt install -y git
git clone --depth 1 https://github.com/xiaozhu2007/dotfiles ~/dotfiles

# =================
# change to the dotfiles directory
# =================
echo "Changing to the ${dotfiledir} directory"
cd "${dotfiledir}" || exit

# =================
# Create symlinks (will overwrite existing files)
# =================
for file in "${files[@]}"; do
    src="${dotfiledir}/.${file}"
    dest="${HOME}/.${file}"
    if [ ! -e "$src" ]; then
        echo "Error: Source file $src does not exist."
        exit 1
    fi
    echo "Creating symlink to $file in home directory."
    ln -sf "$src" "$dest"
done

# =================
# install tools
# =================
apt update
apt install -y curl wget tar unzip zip tealdeer exa
# ripgrep
wget https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
tar xvf ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
mv ripgrep-14.1.1-x86_64-unknown-linux-musl/rg .
rm -r ripgrep-14.1.1-x86_64-unknown-linux-musl/ ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
# fzf
wget https://github.com/junegunn/fzf/releases/download/v0.61.0/fzf-0.61.0-linux_amd64.tar.gz
tar xvf fzf-0.61.0-linux_amd64.tar.gz
rm fzf-0.61.0-linux_amd64.tar.gz
# fd
wget https://github.com/sharkdp/fd/releases/download/v10.2.0/fd_10.2.0_amd64.deb
apt install -y ./fd_10.2.0_amd64.deb
rm fd_10.2.0_amd64.deb
# bat
wget https://github.com/sharkdp/bat/releases/download/v0.25.0/bat_0.25.0_amd64.deb
apt install -y ./bat_0.25.0_amd64.deb
rm bat_0.25.0_amd64.deb

# =================
# chmod & move
# =================
chmod +x fzf rg
mv fzf /usr/bin
mv rg /usr/bin

echo ""
echo "+-------------------------------+"
echo "|     Installation Complete     |"
echo "| Installed: tldr, fd, bat, rg, |"
echo "|           fzf, exa            |"
echo "+-------------------------------+"
echo ""
