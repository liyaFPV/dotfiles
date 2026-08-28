#!/bin/bash

PINE_CONE_VERSION="11.0.2"

exec > >(tee -i log.txt) 2>&1

set -e

GIT_NAME="LiyaFPV"
GIT_EMAIL="lbkmzc942@gmail.com"

PACKAGES_PACMAN=(
  base-devel
  git curl wget fish openssh
  tar gzip unzip 7zip
  nano neovim
  ghostty rofi polybar niri
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
EOF
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

setup_fish() {
  echo "=== Установка Fisher и плагинов для fish ==="
  if ! command -v fisher >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | fish
  fi
  fish -c "fisher install jethrokuan/z edc/bass"

  echo "=== Установка темы Tide (аналог powerlevel10k для fish) ==="
  fish -c "fisher install IlanCosman/tide@v6"
  fish -c "tide configure --auto"

  echo "=== Генерация config.fish ==="
  mkdir -p ~/.config/fish
  touch ~/.config/fish/config.fish
  if ! grep -q 'userScripts' ~/.config/fish/config.fish; then
    cat << EOF >> ~/.config/fish/config.fish
fish_add_path \$HOME/userScripts
EOF
  fi

  echo "=== Смена оболочки на fish ==="
  sudo chsh -s "$(which fish)" "$USER"
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

  if command -v fish >/dev/null 2>&1 && [ "$SHELL" != "$(which fish)" ]; then
    echo "=== Установка fish стандартной оболочкой ==="
    sudo chsh -s "$(which fish)" "$USER"
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
  setup_fish
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