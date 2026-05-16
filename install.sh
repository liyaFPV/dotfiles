#!/bin/bash

exec > >(tee -i log.txt) 2>&1

set -e

echo "=== 1. Подготовка и обновление системы ==="
sudo apt update && sudo apt upgrade -y
sudo apt install -y gnupg software-properties-common curl wget
sudo add-apt-repository -y ppa:appimagelauncher-team/stable
curl -fsSL https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/Debian_13/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/danklinux.gpg

echo "deb [signed-by=/etc/apt/keyrings/danklinux.gpg] https://download.opensuse.org/repositories/home:/AvengeMedia:/danklinux/Debian_13/ /" | \
  sudo tee /etc/apt/sources.list.d/danklinux.list

sudo apt update

echo "=== 2. Установка пакетов ==="
sudo apt install -y \
  git curl wget gpg \
  htop fastfetch \
  filezilla flatpak \
  openssh-server \
  gnome-core gnome-calculator gdm3 \
  libreoffice kdenlive \
  vlc gimp \
  python3 python3-venv python3-dev \
  tar gzip p7zip-full unzip \
  firefox \
  rofi-wayland ffmpeg \
  zsh \
  appimagelauncher libfuse2 \
  pipewire pipewire-audio-client-libraries pipewire-pulse wireplumber pavucontrol xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
  niri waybar swaybg xwayland-satellite brightnessctl kitty cliphist eza fzf lsb-release

echo "=== 3. Установка Oh My Zsh тем и адонов ==="
rm -rf ~/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone --depth=1 https://github.com/marlonrichert/zsh-autocomplete.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

echo "=== 3.5. Автоматическая конфигурация .zshrc ==="
cat << 'EOF' > ~/.zshrc
# Путь к Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Включаем тему Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Все установленные плагины активированы здесь автоматически
plugins=(
  git 
  zsh-autocomplete 
  zsh-autosuggestions 
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Настройки путей для Go и твоих скриптов автоматизации
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/userScripts

# Запрещаем Zsh плодить дубликаты в переменной PATH
typeset -U path
EOF

echo "=== 4. Установка Go ==="
GO_VERSION="1.26.3"
sudo rm -rf /usr/local/go

wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -P /tmp
sudo tar -C /usr/local -xzf /tmp/go${GO_VERSION}.linux-amd64.tar.gz
rm /tmp/go${GO_VERSION}.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
/usr/local/go/bin/go version

echo "=== 5. Установка VS Code ==="
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code

echo "=== 6. Установка конфигов ==="
git config --global user.name "LiyaFPV"
git config --global user.email "lbkmzc942@gmail.com"
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global --list
mkdir -p ~/.config
mkdir -p ~/Applications
mkdir -p ~/userScripts
cp -r Applications/* ~/Applications/ 2>/dev/null || true
cp -r userScripts/* ~/userScripts/ 2>/dev/null || true
cp -r config/* ~/.config/ 2>/dev/null || true
systemctl --user --now enable wireplumber.service
if [ -f ~/userScripts/install.sh ]; then
    chmod +x ~/userScripts/install.sh
    ~/userScripts/install.sh
fi

echo "=== 6.5. Автоматическая установка JetBrainsMono Nerd Font ==="
mkdir -p ~/.local/share/fonts/JetBrainsMono
wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz -P /tmp
tar -xf /tmp/JetBrainsMono.tar.xz -C ~/.local/share/fonts/JetBrainsMono/ --wildcards '*.ttf'
rm /tmp/JetBrainsMono.tar.xz
fc-cache -fv

echo "=== 7. Добавление пользователя в группы управления устройствами ==="
for group in dialout plugdev input video audio; do
    if getent group "$group" > /dev/null; then
        sudo usermod -aG "$group" $USER
        echo "Пользователь $USER успешно добавлен в группу: $group"
    fi
done
echo 'KERNEL=="ttyUSB*", MODE="0666"' | sudo tee /etc/udev/rules.d/99-usb-serial.rules
echo 'KERNEL=="ttyACM*", MODE="0666"' | sudo tee -a /etc/udev/rules.d/99-usb-serial.rules
sudo udevadm control --reload-rules && sudo udevadm trigger

echo "=== 8. Установка Telegram и Discord (Нативные пакеты) ==="

# 1. Установка Telegram через PPA
sudo apt update
sudo apt install -y telegram-desktop
echo "Скачивание Discord..."
wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"
echo "Установка Discord..."
sudo apt install -y /tmp/discord.deb
rm /tmp/discord.deb

echo "=== 9. скачевание AppImage ==="
wget -O ~/Applications/FreeCAD.AppImage "https://release-assets.githubusercontent.com/github-production-release-asset/5736080/d97e16b8-8010-4118-b489-e908208bb313?sp=r&sv=2018-11-09&sr=b&spr=https&se=2026-05-16T08%3A29%3A11Z&rscd=attachment%3B+filename%3DFreeCAD_1.1.1-Linux-x86_64-py311.AppImage&rsct=application%2Foctet-stream&skoid=96c2d410-5711-43a1-aedd-ab1947aa7ab0&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skt=2026-05-16T07%3A28%3A47Z&ske=2026-05-16T08%3A29%3A11Z&sks=b&skv=2018-11-09&sig=zzNPSSeifbA6AYcqfzBiEGIKl8mYJ8bRjre%2Fn%2BcSYQQ%3D&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmVsZWFzZS1hc3NldHMuZ2l0aHVidXNlcmNvbnRlbnQuY29tIiwia2V5Ijoia2V5MSIsImV4cCI6MTc3ODkyMDU0MiwibmJmIjoxNzc4OTE2OTQyLCJwYXRoIjoicmVsZWFzZWFzc2V0cHJvZHVjdGlvbi5ibG9iLmNvcmUud2luZG93cy5uZXQifQ.hLLQfXw85gbd2XjXTGK5F0y9fKuBoU0fSAK54WZAagM&response-content-disposition=attachment%3B%20filename%3DFreeCAD_1.1.1-Linux-x86_64-py311.AppImage&response-content-type=application%2Foctet-stream" \ 
&& chmod +x ~/Applications/FreeCAD.AppImage

wget -O ~/Applications/PineconeMC-Linux-x86_64.AppImage "https://release-assets.githubusercontent.com/github-production-release-asset/561202233/4299d4a1-d383-4d7c-a151-4c571be0180b?sp=r&sv=2018-11-09&sr=b&spr=https&se=2026-05-16T08%3A28%3A29Z&rscd=attachment%3B+filename%3DPineconeMC-Linux-x86_64.AppImage&rsct=application%2Foctet-stream&skoid=96c2d410-5711-43a1-aedd-ab1947aa7ab0&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skt=2026-05-16T07%3A27%3A44Z&ske=2026-05-16T08%3A28%3A29Z&sks=b&skv=2018-11-09&sig=ulQObc4JZ2Q%2BZefs1dZGszufgVrAVaTWydS0smt%2Bo9I%3D&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmVsZWFzZS1hc3NldHMuZ2l0aHVidXNlcmNvbnRlbnQuY29tIiwia2V5Ijoia2V5MSIsImV4cCI6MTc3ODkyMDMwMCwibmJmIjoxNzc4OTE2NzAwLCJwYXRoIjoicmVsZWFzZWFzc2V0cHJvZHVjdGlvbi5ibG9iLmNvcmUud2luZG93cy5uZXQifQ.JnD5foWRlH5KzYr66bJrA-8OIQDjOGPMoHChXJx_INw&response-content-disposition=attachment%3B%20filename%3DPineconeMC-Linux-x86_64.AppImage&response-content-type=application%2Foctet-stream"
&& chmod +x ~/Applications/PineconeMC-Linux-x86_64.AppImage

echo "=== 10. Смена оболочки на Zsh ==="
sudo chsh -s $(which zsh) $USER

echo "=== Всё готово! Перезапуск систему ==="
sudo reboot