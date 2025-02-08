#!/bin/bash

## Criar swapfile
if [ ! -f /swapfile ]; then
  sudo fallocate -l 8G /swapfile  # Allocate size
  sudo chmod 600 /swapfile                # Set proper permission
  sudo mkswap /swapfile                   # Setup swap         
  sudo swapon /swapfile                   # Enable swap
  echo "/swapfile none swap defaults 0 0" | sudo tee /etc/fstab -a # Add to fstab
fi

## desbostificar o ubuntu

if [ ! -f ./already_runned_debullshit ]; then
  touch already_runned_debullshit
  chmod +x ubuntu-debullshit_modified.sh
  sudo ./ubuntu-debullshit_modified.sh 
fi

#programas aleatórios
sudo apt update
sudo apt install -y wget git vim valgrind neofetch gparted btop texlive-full python3-pip tree cloc timeshift

##install flatpak remotes

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists gnome-nightly https://nightly.gnome.org/gnome-nightly.flatpakrepo

awk '{print "flatpak install -y "$1" "$2}' ./flatpak.txt > /tmp/flatpak_install.sh
sudo chmod +x /tmp/flatpak_install.sh
/tmp/flatpak_install.sh

## Programas que rodam nativos

## instalar gh
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	sudo apt update && sudo apt install -y gh
## instalar vscode

echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections

sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg

sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code 

## Docker

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
sudo apt install distrobox

### Nvidia

wget https://github.com/bayasdev/envycontrol/releases/download/v3.5.1/python3-envycontrol_3.5.1-1_all.deb
sudo apt install -y ./python3-envycontrol_3.5.1-1_all.deb



## Remove some packages
sudo apt autoremove -y 
sudo snap remove firefox



## Aesthetics
gsettings set org.gnome.desktop.background picture-uri-dark https://raw.githubusercontent.com/viniciusdutra314/MyUbuntu/refs/heads/main/images/wallpaper.jpeg
gsettings set org.gnome.desktop.background picture-uri https://raw.githubusercontent.com/viniciusdutra314/MyUbuntu/refs/heads/main/images/wallpaper.jpeg
