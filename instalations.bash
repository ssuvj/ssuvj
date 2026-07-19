# if from zero helpfull i always mess up
# 1. copyq
sudo apt update -y
sudo apt install copyq copyq-plugins

# 2. sober
sudo apt update -y
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# reboot gnu/linux
flatpak install flathub org.vinegarhq.Sober

# 3. flakon
sudo apt update -y
sudo apt install falkon

# 4. freetube
sudo apt update -y
flatpak install io.freetubeapp.FreeTube.flatpakref

# 5. xterm terminal
sudo apt update -y
sudo apt install xterm

# 6. inxi
sudo apt update -y
sudo apt install inxi

# 7. fastfetch
sudo apt update -y
sudo apt install fastfetch
