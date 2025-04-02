#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in $HOME/dotfiles
# Thanks https://github.com/CoreyMSchafer/dotfiles/blob/master/install.sh
############################

# dotfiles directory
dotfiledir="${HOME}/dotfiles"

# list of files/folders to symlink in ${homedir}
files=(bashrc bash_profile bash_prompt aliases func profile)

# clone the repo
apt install -y git
git clone https://github.com/xiaozhu2007/dotfiles ~/dotfiles

# change to the dotfiles directory
echo "Changing to the ${dotfiledir} directory"
cd "${dotfiledir}" || exit

# create symlinks (will overwrite old dotfiles)
for file in "${files[@]}"; do
    echo "Creating symlink to $file in home directory."
    ln -sf "${dotfiledir}/.${file}" "${HOME}/.${file}"
done

# install tools
apt update
apt install -y curl wget tar unzip zip
# ripgrep
wget https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
tar xvf ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
mv ripgrep-14.1.1-x86_64-unknown-linux-musl/rg .
rm -r ripgrep-14.1.1-x86_64-unknown-linux-musl/ ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
# fzf
wget https://github.com/junegunn/fzf/releases/download/v0.61.0/fzf-0.61.0-linux_amd64.tar.gz
tar xvf fzf-0.61.0-linux_amd64.tar.gz
rm fzf-0.61.0-linux_amd64.tar.gz
# onefetch
# wget https://github.com/o2sh/onefetch/releases/download/2.23.1/onefetch_2.23.1_amd64.deb
# apt install -y ./onefetch_2.23.1_amd64.deb
# fd
wget https://github.com/sharkdp/fd/releases/download/v10.2.0/fd_10.2.0_amd64.deb
apt install -y ./fd_10.2.0_amd64.deb
# bat
wget https://github.com/sharkdp/bat/releases/download/v0.25.0/bat_0.25.0_amd64.deb
apt install -y ./bat_0.25.0_amd64.deb

# chmod & move
chmod +x fzf rg
mv fzf /usr/bin
mv rg /usr/bin
echo "Installation Complete!"
