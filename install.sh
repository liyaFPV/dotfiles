#!/bin/bash

<<<<<<< HEAD
PINE_CONE_VERSION="11.0.2"
=======
GO_VERSION="1.26.3"
FreeCAD_URL="https://release-assets.githubusercontent.com/github-production-release-asset/5736080/d97e16b8-8010-4118-b489-e908208bb313?sp=r&sv=2018-11-09&sr=b&spr=https&se=2026-05-16T08%3A29%3A11Z&rscd=attachment%3B+filename%3DFreeCAD_1.1.1-Linux-x86_64-py311.AppImage&rsct=application%2Foctet-stream&skoid=96c2d410-5711-43a1-aedd-ab1947aa7ab0&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skt=2026-05-16T07%3A28%3A47Z&ske=2026-05-16T08%3A29%3A11Z&sks=b&skv=2018-11-09&sig=zzNPSSeifbA6AYcqfzBiEGIKl8mYJ8bRjre%2Fn%2BcSYQQ%3D&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmVsZWFzZS1hc3NldHMuZ2l0aHVidXNlcmNvbnRlbnQuY29tIiwia2V5Ijoia2V5MSIsImV4cCI6MTc3ODkyMDU0MiwibmJmIjoxNzc4OTE2OTQyLCJwYXRoIjoicmVsZWFzZWFzc2V0cHJvZHVjdGlvbi5ibG9iLmNvcmUud2luZG93cy5uZXQifQ.hLLQfXw85gbd2XjXTGK5F0y9fKuBoU0fSAK54WZAagM&response-content-disposition=attachment%3B%20filename%3DFreeCAD_1.1.1-Linux-x86_64-py311.AppImage&response-content-type=application%2Foctet-stream"
PineconeMC_URL="https://release-assets.githubusercontent.com/github-production-release-asset/561202233/4299d4a1-d383-4d7c-a151-4c571be0180b?sp=r&sv=2018-11-09&sr=b&spr=https&se=2026-05-16T08%3A28%3A29Z&rscd=attachment%3B+filename%3DPineconeMC-Linux-x86_64.AppImage&rsct=application%2Foctet-stream&skoid=96c2d410-5711-43a1-aedd-ab1947aa7ab0&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skt=2026-05-16T07%3A27%3A44Z&ske=2026-05-16T08%3A28%3A29Z&sks=b&skv=2018-11-09&sig=ulQObc4JZ2Q%2BZefs1dZGszufgVrAVaTWydS0smt%2Bo9I%3D&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmVsZWFzZS1hc3NldHMuZ2l0aHVidXNlcmNvbnRlbnQuY29tIiwia2V5Ijoia2V5MSIsImV4cCI6MTc3ODkyMDMwMCwibmJmIjoxNzc4OTE2NzAwLCJwYXRoIjoicmVsZWFzZWFzc2V0cHJvZHVjdGlvbi5ibG9iLmNvcmUud2luZG93cy5uZXQifQ.JnD5foWRlH5KzYr66bJrA-8OIQDjOGPMoHChXJx_INw&response-content-disposition=attachment%3B%20filename%3DPineconeMC-Linux-x86_64.AppImage&response-content-type=application%2Foctet-stream"
>>>>>>> b21e1ac679ec13ec2d214b086504c50adac824b0

exec > >(tee -i log.txt) 2>&1

set -e

<<<<<<< HEAD
GIT_NAME="LiyaFPV"
GIT_EMAIL="lbkmzc942@gmail.com"

PACKAGES_PACMAN=(
  base-devel
  git curl wget zsh openssh
  tar gzip unzip 7zip
  nano neovim
  kitty rofi polybar niri
  gnome-shell gnome-session gdm
  gnome-control-center gnome-settings-daemon gnome-shell-extensions
  gnome-terminal nautilus gnome-calculator gnome-text-editor gnome-tweaks
  xdg-desktop-portal-gnome xdg-desktop-portal-gtk xdg-desktop-portal gvfs
  firefox chromium btop filezilla
  telegram-desktop code python python-pip thunar obs-studio freecad golang
  audacity kdenlive libreoffice-fresh uv platformio-core
  ttf-jetbrains-mono-nerd
  pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol
  swaybg swaylock brightnessctl xwayland-satellite cliphist eza fzf
  xclip xdotool fuse2 flatpak
)

PACKAGES_AUR=(
  vial-appimage
  happ-desktop-bin
  ayugram-desktop
  yandex-music
  waypaper
  discord
  arduino-ide-bin
)

banner() {
  tput setaf 2
  cat << 'EOF'
 .____    .__               _________________________   ____
|    |   |__|___.__._____  \_   _____/\______   \   \ /   /
|    |   |  <   |  |\__  \  |    __)   |     ___/\   Y   / 
|    |___|  |\___  | / __ \_|     \    |    |     \     /  
|_______ \__|/ ____|(____  /\___  /    |____|      \___/   
        \/   \/          \/     \/
  tput sgr0
}

check_root() {
  if [ "$(id -u)" = "0" ]; then
    echo "Ошибка: скрипт нужно запускать от обычного пользователя (не root)."
    exit 1
  fi
}

update_system() {
  echo "=== Обновление системы ==="
  sudo pacman -Syu --noconfirm
}

install_yay() {
  echo "=== Установка AUR-помощника yay ==="
  if command -v yay >/dev/null 2>&1; then
    echo "yay уже установлен."
    return
  fi
  sudo pacman -S --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/yay.git /tmp/yay-build
  cd /tmp/yay-build
  makepkg -si --noconfirm
  cd -
}

install_pacman_packages() {
  echo "=== Установка пакетов из официальных репозиториев ==="
  sudo pacman -S --needed --noconfirm "${PACKAGES_PACMAN[@]}"
}

install_aur_packages() {
  echo "=== Установка пакетов из AUR (может занять время) ==="
  yay -S --needed --noconfirm "${PACKAGES_AUR[@]}"
}

setup_zsh() {
  echo "=== Установка Oh My Zsh и powerlevel10k ==="
  rm -rf ~/.oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  git clone --depth=1 https://github.com/marlonrichert/zsh-autocomplete.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete"
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

  echo "=== Генерация .zshrc ==="
  cat << EOF > ~/.zshrc
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git
  zsh-autocomplete
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source \$ZSH/oh-my-zsh.sh
export PATH=\$PATH:\$HOME/userScripts
typeset -U path
EOF

  echo "=== Смена оболочки на Zsh ==="
  sudo chsh -s "$(which zsh)" "$USER"
}

setup_git() {
  echo "=== Настройка git ==="
  git config --global user.name "$GIT_NAME"
  git config --global user.email "$GIT_EMAIL"
  git config --global init.defaultBranch main
  git config --global color.ui auto

  echo "=== Настройка SSH-ключа для GitHub ==="
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh

  if [ -f ~/.ssh/id_ed25519 ]; then
    echo "SSH-ключ ~/.ssh/id_ed25519 уже существует."
  else
    read -rp "Вставить готовый приватный ключ? (y/N): " paste_key
    case "${paste_key:-n}" in
      y|Y)
        echo "Вставь приватный ключ и в конце напиши строку END, затем Enter:"
        : > ~/.ssh/id_ed25519
        while read -r line; do
          [ "$line" = "END" ] && break
          echo "$line" >> ~/.ssh/id_ed25519
        done
        chmod 600 ~/.ssh/id_ed25519
        ;;
      *)
        ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f ~/.ssh/id_ed25519 -N ""
        ;;
    esac
  fi

  eval "$(ssh-agent -s)" >/dev/null
  ssh-add ~/.ssh/id_ed25519 >/dev/null 2>&1 || true

  echo "Публичный ключ (добавь его в GitHub → Settings → SSH and GPG keys):"
  cat ~/.ssh/id_ed25519.pub

  echo "Проверка подключения к GitHub..."
  ssh -T git@github.com 2>&1 || true
}

setup_usb_permissions() {
  echo "=== Настройка прав доступа к USB-устройствам ==="
  if ! getent group plugdev > /dev/null; then
    sudo groupadd -r plugdev 2>/dev/null || true
    echo "Группа plugdev создана."
  fi
  for group in uucp input video audio dialout plugdev; do
    if getent group "$group" > /dev/null; then
      sudo usermod -aG "$group" "$USER"
      echo "Пользователь $USER добавлен в группу: $group"
    fi
  done

  echo 'KERNEL=="ttyUSB*", MODE="0666"' | sudo tee /etc/udev/rules.d/99-usb-serial.rules > /dev/null
  echo 'KERNEL=="ttyACM*", MODE="0666"' | sudo tee -a /etc/udev/rules.d/99-usb-serial.rules > /dev/null
  sudo udevadm control --reload-rules && sudo udevadm trigger
}

setup_display_manager() {
  echo "=== Включение GDM (экран входа) ==="
  sudo systemctl enable --now gdm.service 2>/dev/null || true
  echo "GDM включён."
}

setup_audio() {
  echo "=== Настройка PipeWire (звук) ==="
  systemctl --user --now enable pipewire pipewire-pulse wireplumber 2>/dev/null || true
  echo "PipeWire включён."
}

setup_flatpak() {
  echo "=== Настройка Flatpak ==="
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  flatpak override --user --device=all
  echo "Доступ Flatpak к USB-устройствам разрешён."
}

install_attack_shark() {
  echo "=== Установка Attack Shark (X11 Electron) ==="
  curl -fsSL https://raw.githubusercontent.com/liyaFPV/attack-shark-x11-electron-ru/main/install.sh | bash
}

install_opencode() {
  echo "=== Установка opencode ==="
  curl -fsSL https://opencode.ai/install | bash
}

install_appimages() {
  echo "=== Установка AppImage ==="
  mkdir -p ~/Applications
  echo "Скачивание PineconeMC..."
  wget -q --show-progress -O ~/Applications/PineconeMC.AppImage \
    "https://github.com/ElyPrismLauncher/Launcher/releases/download/${PINE_CONE_VERSION}/PineconeMC-Linux-x86_64.AppImage"
  chmod +x ~/Applications/PineconeMC.AppImage
}

copy_configs() {
  echo "=== Копирование конфигов ==="
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  mkdir -p ~/.config ~/Applications ~/userScripts ~/Wallpapers

  cp -r "$SCRIPT_DIR/home/." ~/ 2>/dev/null || true
  cp -r "$SCRIPT_DIR/config/." ~/.config/ 2>/dev/null || true
  cp -r "$SCRIPT_DIR/userScripts/." ~/userScripts/ 2>/dev/null || true
  cp -r "$SCRIPT_DIR/Wallpapers/." ~/Wallpapers/ 2>/dev/null || true

  if [ -d ~/userScripts ]; then
    chmod +x ~/userScripts/* 2>/dev/null || true
  fi

  if command -v zsh >/dev/null 2>&1 && [ "$SHELL" != "$(which zsh)" ]; then
    echo "=== Установка Zsh стандартной оболочкой ==="
    sudo chsh -s "$(which zsh)" "$USER"
  fi

  if systemctl --user list-units 2>/dev/null | grep -q "wireplumber"; then
    systemctl --user --now enable wireplumber.service
  fi

  if [ -f ~/userScripts/install.sh ]; then
    echo "=== Настройка доступа к роутеру ==="
    ~/userScripts/install.sh
  fi

  if command -v flatpak >/dev/null 2>&1; then
    setup_flatpak
  fi
}

configs_only() {
  echo "=== Режим: только конфиги ==="
  copy_configs
  echo "=== Конфигурация успешно обновлена! ==="
}

full_install() {
  echo "=== Режим: полная установка ==="
  update_system
  install_yay
  install_pacman_packages
  install_aur_packages
  setup_flatpak
  setup_audio
  setup_display_manager
  setup_zsh
  setup_git
  setup_usb_permissions
  install_attack_shark
  install_opencode
  install_appimages
  copy_configs
  echo "=== Всё готово! Перезапуск системы через 5 секунд... ==="
  sleep 5
  sudo reboot
}

banner
check_root

echo "Выберите режим работы скрипта:"
echo "1) Полная установка системы и пакетов + конфиги"
echo "2) Только обновление конфигурационных файлов (dotfiles)"
echo "3) Выход"
read -rp "Введите цифру (1, 2 или 3): " USER_CHOICE

case "$USER_CHOICE" in
  1) full_install ;;
  2) configs_only ;;
  3) echo "Выход."; exit 0 ;;
  *) echo "Неверный ввод. Выход."; exit 1 ;;
esac
=======
# --- Интерактивное меню ---
echo "Выберите режим работы скрипта:"
echo "1) Полная установка системы и пакетов + конфиги"
echo "2) Только обновление конфигурационных файлов (dotfiles)"
read -rp "Введите цифру (1 или 2): " USER_CHOICE

case "$USER_CHOICE" in
    1)
        echo "Выбран режим: Полная установка."
        ;;
    2)
        echo "Выбран режим: Только обновление конфигов."
        ;;
    *)
        echo "Неверный ввод. Выход."
        exit 1
        ;;
esac # <-- Исправлено здесь (было 'case')

install_packages_and_soft() {
    echo "=== 1. Подготовка и обновление системы ==="
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y gnupg curl wget apt-transport-https
    sudo mkdir -p /etc/apt/keyrings

    curl -fsSL "https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/Debian_13/Release.key" | \
      gpg --dearmor | sudo tee /etc/apt/keyrings/danklinux.gpg > /dev/null

    echo "deb [signed-by=/etc/apt/keyrings/danklinux.gpg] https://download.opensuse.org/repositories/home:/AvengeMedia:/danklinux/Debian_13/ /" | \
      sudo tee /etc/apt/sources.list.d/danklinux.list

    sudo apt update

    echo "=== 2. Установка пакетов ==="
    sudo apt install -y --no-install-recommends \
      git curl wget gpg \
      htop fastfetch \
      filezilla flatpak \
      openssh-server \
      gnome-core gnome-calculator gdm3 thunar\
      libreoffice kdenlive \
      vlc gimp \
      python3 python3-venv python3-dev \
      tar gzip p7zip-full unzip \
      rofi ffmpeg \
      zsh \
      libfuse2 \
      pipewire pipewire-audio-client-libraries pipewire-pulse wireplumber pavucontrol xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
      niri waybar swaybg xwayland-satellite brightnessctl kitty cliphist eza fzf lsb-release swaylock \
      nautilus- gnome-terminal-

    echo "=== 3. Установка Oh My Zsh тем и адонов ==="
    rm -rf ~/.oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    git clone --depth=1 https://github.com/marlonrichert/zsh-autocomplete.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete"
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

    echo "=== 3.5. Автоматическая конфигурация .zshrc ==="
    cat << 'EOF' > ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git 
  zsh-autocomplete 
  zsh-autosuggestions 
  zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/userScripts
typeset -U path
EOF

    echo "=== 4. Установка Go ==="
    if [ -x /usr/local/go/bin/go ] && /usr/local/go/bin/go version | grep -q "go${GO_VERSION}"; then
        echo "Go версии ${GO_VERSION} уже установлен. Пропускаем скачивание."
    else
        echo "Установка Go версии ${GO_VERSION}..."
        sudo rm -rf /usr/local/go
        wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -P /tmp
        sudo tar -C /usr/local -xzf /tmp/go${GO_VERSION}.linux-amd64.tar.gz
        rm /tmp/go${GO_VERSION}.linux-amd64.tar.gz
        if ! grep -q '/usr/local/go/bin' ~/.bashrc; then
            echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
        fi
    fi
    /usr/local/go/bin/go version

    echo "=== 5. Установка VS Code ==="
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg > /dev/null
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    sudo apt update
    sudo apt install -y code

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
    sudo apt update
    sudo apt install telegram-desktop -y
    echo "Скачивание Discord..."
    wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"
    echo "Установка Discord..."
    sudo apt install /tmp/discord.deb -y
    rm /tmp/discord.deb

    echo "=== 9. скачевание AppImage ==="
    wget -O ~/Applications/FreeCAD.AppImage "${FreeCAD_URL}" && chmod +x ~/Applications/FreeCAD.AppImage
    wget -O ~/Applications/PineconeMC-Linux-x86_64.AppImage "${PineconeMC_URL}" && chmod +x ~/Applications/PineconeMC-Linux-x86_64.AppImage

    echo "=== 10. Смена оболочки на Zsh ==="
    sudo chsh -s $(which zsh) $USER
}

update_only_configs() {
    echo "=== 6. Установка и обновление конфигов ==="
    if command -v flatpak &> /dev/null; then
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    fi
    
    git config --global user.name "LiyaFPV"
    git config --global user.email "lbkmzc942@gmail.com"
    git config --global init.defaultBranch main
    git config --global color.ui auto
    git config --global --list
    
    mkdir -p ~/.config
    mkdir -p ~/Applications
    mkdir -p ~/userScripts
    mkdir -p ~/Wallpapers
    
    cp -r Applications/* ~/Applications/ 2>/dev/null || true
    cp -r userScripts/* ~/userScripts/ 2>/dev/null || true
    cp -r config/* ~/.config/ 2>/dev/null || true
    cp -r Wallpapers/* ~/Wallpapers/ 2>/dev/null || true
    cp -r home/* ~ 2>/dev/null || true
    
    if systemctl --user list-units | grep -q "wireplumber"; then
        systemctl --user --now enable wireplumber.service
    fi
    
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
    
    echo "=== Конфигурация успешно обновлена! ==="
}

if [ "$USER_CHOICE" -eq 1 ]; then
    # Запускаем всё последовательно
    install_packages_and_soft
    update_only_configs
    echo "=== Всё готово! Перезапуск системы через 5 секунд... ==="
    sleep 5
    sudo reboot
elif [ "$USER_CHOICE" -eq 2 ]; then
    # Запускаем только конфиги
    update_only_configs
fi
>>>>>>> b21e1ac679ec13ec2d214b086504c50adac824b0
