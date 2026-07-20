#!/bin/bash
# =========================================================================
# SCRIPT DE AUTOMATIZARE REVIZUIT DUPĂ INSTALATIONS.BASH ȘI INFO (ssuvj)
# =========================================================================

echo "=== 1. SINCRONIZARE ȘI INSTALARE PACHETE SPECIFICATE ==="
sudo apt update -y
# Instalează exact pachetele pe care le-ai listat, minus feh și mediul mare MATE
sudo apt install -y openbox tint2 rofi xcape picom obconf lxappearance pcmanfm mate-terminal engrampa mate-utils mate-calc mate-power-manager network-manager-gnome volumeicon-alsa dunst git adwaita-icon-theme xinit xterm dconf-cli

# Verificare structurală
if [ ! -x /usr/bin/openbox ]; then 
    echo "🚨 Oprire: Nucleul Openbox nu a putut fi instalat!"
    exit 1
fi

echo "=== 2. DESCARCARE REPOZITORIU ȘI CREARE STRUCTURĂ .CONFIG ==="
cd ~
rm -rf ssuvj
git clone https://github.com/ssuvj/ssuvj/tree/main

# Creare directoare fără spații în nume (corectat din fișierul tău info)
mkdir -p ~/.config/openbox
mkdir -p ~/.config/tint2
mkdir -p ~/.config/rofi
mkdir -p ~/.config/pcmanfm/default

echo "=== 3. MUTARE FIȘIERE CONFORM STRUCTURII CURENTE GITHUB ==="
# Copiere exactă bazată pe imaginea ta de ecran și fișierele din gnu_linux
cp ~/ssuvj/gnu_linux/rc.xml ~/.config/openbox/rc.xml
cp ~/ssuvj/gnu_linux/tint2.rc ~/.config/tint2/tint2rc
cp ~/ssuvj/gnu_linux/autostart\(openbox\) ~/.config/openbox/autostart
chmod +x ~/.config/openbox/autostart

# Copiere imagine de fundal specificată în gnu_linux
mkdir -p ~/Pictures/Wallpapers
cp "~/ssuvj/gnu_linux/2q1yk0tc0r0f1.png" ~/Pictures/Wallpapers/desktop_wallpaper.png 2>/dev/null || true

echo "=== 4. CONFIGURARE SESIUNE CLI (STARTX) ȘI INTEGRARE AUTOSTART ==="
echo "exec openbox-session" > ~/.xinitrc

# Suprascriere fișier autostart pentru a rula pachetele din instalations.bash
cat << 'EOF' > ~/.config/openbox/autostart
picom --experimental-backends &

if [ -f ~/Pictures/Wallpapers/desktop_wallpaper.png ]; then
    mkdir -p ~/.config/pcmanfm/default
    echo -e "[*]\nwallpaper_mode=crop\nwallpaper_common=1\nwallpaper=$HOME/Pictures/Wallpapers/desktop_wallpaper.png" > ~/.config/pcmanfm/default/desktop-items-0.conf
    pcmanfm --desktop &
else
    pcmanfm --desktop &
fi

tint2 &
GTK_THEME=Adwaita nm-applet &
volumeicon &
dunst &
mate-power-manager &
xcape -e 'Super_L=Alt_L|F3' &
EOF

echo "=== 5. ASPECT INTEGRAT (DARK MODE ȘI FONT 10 - EXACT DIN INFO) ==="
# Setează tema întunecată la nivel de sistem (GTK)
mkdir -p ~/.config/gtk-3.0
echo -e "[Settings]\ngtk-theme-name = Adwaita-dark\ngtk-application-prefer-dark-theme = true" > ~/.config/gtk-3.0/settings.ini
echo 'gtk-theme-name = "Adwaita-dark"' > ~/.gtkrc-2.0

# Calibrare font Monospace dimensiune 10 pentru mate-terminal (reparat din info)
dconf write /org/mate/terminal/profiles/default/use-system-font false
dconf write /org/mate/terminal/profiles/default/font "'Monospace 10'"

echo "=== 6. CURĂȚARE INTEGRALĂ ȘI REBOOT ==="
# Elimină dintr-o lovitură orice manager de login și resturi de desktop vechi
sudo apt purge -y mate-desktop-environment* mate-core mate-desktop* lightdm gdm3 sddm nodm slim
sudo apt autoremove -y

echo "=== TOTUL ESTE ÎN ORDINE! REBOOT ÎN 5 SECUNDE ==="
sleep 5
sudo reboot
