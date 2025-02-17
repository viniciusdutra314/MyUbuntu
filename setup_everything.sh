#!/bin/bash

## Criar swapfile
sudo btrfs filesystem mkswapfile --size 16G /swapfile
sudo swapon /swapfile
echo "/swapfile none swap defaults 0 0" | sudo tee /etc/fstab -a # Add to fstab

## desbostificar o ubuntu
if [ ! -f ./already_runned_debullshit ]; then
  touch already_runned_debullshit
  chmod +x ubuntu-debullshit_modified.sh
  sudo ./ubuntu-debullshit_modified.sh 
fi
## instalar os flatpaks manualmente
flatpak install flathub io.github.vikdevelop.SaveDesktop -y


#atualizar todas os ppa 
sudo apt install ca-certificates curl wget gpg
#gh
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null 
#Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#vscode
echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
#fasfetch
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch

#instalar programas dos ppa (ordem que aparece)
sudo apt update 
sudo apt install -y gh apt-transport-https code docker-ce docker-ce-cli  \
containerd.io docker-buildx-plugin docker-compose-plugin fastfetch

# docker sem sudo
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

#programas variados
sudo apt install -y wget git cmake make vim valgrind  gparted htop btop python3-pip \
tree cloc speedtest-cli ffmpeg distrobox

### Nvidia

wget https://github.com/bayasdev/envycontrol/releases/download/v3.5.1/python3-envycontrol_3.5.1-1_all.deb
sudo apt install -y ./python3-envycontrol_3.5.1-1_all.deb

if command -v nvidia-smi &>/dev/null; then
    echo "nvidia-smi exists"
    sudo apt install -y nvidia-cuda-toolkit
fi

## Terminal

sudo apt-get install -y tilix tmux
sudo apt remove -y --purge gnome-terminal
sudo apt install -y zsh 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

## Gnome
sudo apt-get install -y gnome-shell-pomodoro

##flameshot
gsettings set org.gnome.shell.keybindings show-screenshot-ui '[]'
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'flatpak run org.flameshot.Flameshot gui'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 'Print'

## Remove unused

sudo apt autoremove -y 
sudo apt update
sudo apt upgrade