#!/bin/bash
echo "=== PASUL 1: INSTALARE PACHETE ==="
sudo apt update -y
sudo apt install -y openbox tint2 rofi xcape picom obconf lxappearance pcmanfm mate-terminal engrampa mate-utils mate-calc mate-power-manager network-manager-gnome volumeicon-alsa dunst git adwaita-icon-theme xinit xterm dconf-cli

if [ ! -x /usr/bin/openbox ]; then echo "🚨 Openbox nu s-a instalat!"; exit 1; fi

echo "=== PASUL 2: CONFIGURARE DIRECTOARE ȘI GITHUB ==="
mkdir -p ~/.config/openbox ~/.config/tint2 ~/.config/rofi ~/.config/pcmanfm/default
cd /tmp && rm -rf ssuvj && git clone https://github.com/ssuvj/ssuvj/tree/main
if [ -d "/tmp/ssuvj/gnu_linux/.config" ]; then cp -r /tmp/ssuvj/gnu_linux/.config/* ~/.config/; else cp -r /tmp/ssuvj/gnu_linux/* ~/.config/openbox/ 2>/dev/null; cp /tmp/ssuvj/tint2rc ~/.config/tint2/ 2>/dev/null; fi

mkdir -p ~/Pictures/Wallpapers
cp "/tmp/ssuvj/penguin watur" ~/Pictures/Wallpapers/desktop_wallpaper.png 2>/dev/null || true

echo "=== PASUL 3: SCRIPTURI START ==="
echo "exec openbox-session" > ~/.xinitrc
cat << 'EOF' > ~/.config/openbox/autostart
picom --experimental-backends &
mkdir -p ~/.config/pcmanfm/default
echo -e "[*]\nwallpaper_mode=crop\nwallpaper_common=1\nwallpaper=$HOME/Pictures/Wallpapers/desktop_wallpaper.png" > ~/.config/pcmanfm/default/desktop-items-0.conf
pcmanfm --desktop &
tint2 &
GTK_THEME=Adwaita nm-applet &
volumeicon &
dunst &
mate-power-manager &
xcape -e 'Super_L=Alt_L|F3' &
EOF

echo "=== PASUL 4: ASPECT ȘI PURGE ==="
mkdir -p ~/.config/gtk-3.0
echo -e "[Settings]\ngtk-theme-name = Adwaita-dark\ngtk-application-prefer-dark-theme = true" > ~/.config/gtk-3.0/settings.ini
echo 'gtk-theme-name = "Adwaita-dark"' > ~/.gtkrc-2.0
dconf write /org/mate/terminal/profiles/default/use-system-font false
dconf write /org/mate/terminal/profiles/default/font "'Monospace 10'"

sudo apt purge -y mate-desktop-environment* mate-core mate-desktop* lightdm gdm3 sddm nodm slim && sudo apt autoremove -y
echo "=== REBOOT ÎN 5 SECUNDE ===" && sleep 5 && sudo reboot
# 
