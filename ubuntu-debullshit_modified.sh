#!/usr/bin/env bash

##this is a headless version of https://github.com/polkaulfield/ubuntu-debullshit
##customed to my personal taste 

disable_ubuntu_report() {
    ubuntu-report send no
    apt remove ubuntu-report -y
}

remove_appcrash_popup() {
    apt remove apport apport-gtk -y
}


disable_terminal_ads() {
    sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news
    pro config set apt_news=false
}

update_system() {
    apt update && apt upgrade -y
}


setup_flathub() {
    apt install flatpak -y
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    apt install --install-suggests gnome-software -y
}

gsettings_wrapper() {
    if ! command -v dbus-launch; then
        sudo apt install dbus-x11 -y
    fi
    sudo -Hu $(logname) dbus-launch gsettings "$@"
}

set_fonts() {
	gsettings_wrapper set org.gnome.desktop.interface monospace-font-name "Monospace 10"
}

setup_vanilla_gnome() {
    apt install qgnomeplatform-qt5 -y
    apt install gnome-session fonts-cantarell adwaita-icon-theme gnome-backgrounds gnome-tweaks vanilla-gnome-default-settings gnome-shell-extension-manager -y && apt remove ubuntu-session yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound -y
    set_fonts
    restore_background
}

restore_background() {
    gsettings_wrapper set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/blobs-l.svg'
    gsettings_wrapper set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/gnome/blobs-l.svg'
}

setup_julianfairfax_repo() {
    command -v curl || apt install curl -y
    curl -s https://julianfairfax.gitlab.io/package-repo/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/julians-package-repo.gpg
    echo 'deb [ signed-by=/usr/share/keyrings/julians-package-repo.gpg ] https://julianfairfax.gitlab.io/package-repo/debs packages main' | sudo tee /etc/apt/sources.list.d/julians-package-repo.list
    apt update
}

install_adwgtk3() {    
    apt install adw-gtk3 -y
    if command -v flatpak; then
        flatpak install -y runtime/org.gtk.Gtk3theme.adw-gtk3-dark
        flatpak install -y runtime/org.gtk.Gtk3theme.adw-gtk3
    fi
    if [ "$(gsettings_wrapper get org.gnome.desktop.interface color-scheme | tail -n 1)" == ''\''prefer-dark'\''' ]; then
        gsettings_wrapper set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
        gsettings_wrapper set org.gnome.desktop.interface color-scheme prefer-dark
    else
        gsettings_wrapper set org.gnome.desktop.interface gtk-theme adw-gtk3
    fi
}

install_icons() {
    wget https://deb.debian.org/debian/pool/main/a/adwaita-icon-theme/adwaita-icon-theme_46.0-1_all.deb -O /tmp/adwaita-icon-theme.deb
    apt install /tmp/adwaita-icon-theme.deb -y
    apt install morewaita -y    
}

check_root_user() {
    if [ "$(id -u)" != 0 ]; then
        echo 'Please run the script as root!'
        echo 'We need to do administrative tasks'
        exit
    fi
}


main() {
    check_root_user
    disable_ubuntu_report
    remove_appcrash_popup
    disable_terminal_ads
    update_system
    setup_flathub
    update_system
    setup_vanilla_gnome
    update_system
    setup_julianfairfax_repo
    install_adwgtk3
    install_icons
}

