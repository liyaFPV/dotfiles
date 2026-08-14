#!/bin/bash

echo "=== Скрипт настройки и установки зависимостей ==="
echo ""

echo "[1/3] Установка зависимостей через sudo..."

if command -v apt-get >/dev/null 2>&1; then
    PM="apt"
    sudo apt-get update
elif command -v pacman >/dev/null 2>&1; then
    PM="pacman"
elif command -v dnf >/dev/null 2>&1; then
    PM="dnf"
else
    PM="unknown"
    echo "Не удалось определить пакетный менеджер. Устанавливайте зависимости вручную."
fi

ensure_installed() {
    local bin="$1"
    local apt_pkg="$2"
    local pacman_pkg="$3"
    local dnf_pkg="$4"

    if command -v "$bin" >/dev/null 2>&1; then
        echo "$bin уже установлен. Пропускаем."
        return
    fi

    echo "Установка $bin ($pacman_pkg)..."
    case "$PM" in
        apt)     sudo apt-get install -y "$apt_pkg" ;;
        pacman)  sudo pacman -S --needed --noconfirm "$pacman_pkg" ;;
        dnf)     sudo dnf install -y "$dnf_pkg" ;;
    esac
}

ensure_installed expect      expect                expect                  expect
ensure_installed telnet      telnet                inetutils               telnet
ensure_installed exiftool    libimage-exiftool-perl perl-image-exiftool    perl-Image-ExifTool
ensure_installed zenity      zenity                zenity                  zenity
ensure_installed swaybg      swaybg                swaybg                  swaybg
ensure_installed firefox     firefox               firefox                 firefox

echo "Зависимости успешно установлены."
echo ""

echo "[2/3] Настройка данных доступа к роутеру"

read -p "Введите IP-адрес роутера [192.168.1.1]: " INPUT_HOST
INPUT_HOST=${INPUT_HOST:-192.168.1.1}

read -p "Введите имя пользователя [admin]: " INPUT_USER
INPUT_USER=${INPUT_USER:-admin}

read -s -p "Введите пароль от роутера: " INPUT_PASSWORD
echo ""

echo ""
echo "[3/3] Сохранение переменных в оболочку (bash и zsh)..."

REAL_USER=${SUDO_USER:-$USER}
if [ "$REAL_USER" = "root" ]; then
    REAL_HOME="/root"
else
    REAL_HOME="/home/$REAL_USER"
fi

add_to_rc() {
    local RC_FILE="$1"
    [ -z "$RC_FILE" ] && return
    touch "$RC_FILE"
    sed -i "/ROUTER_HOST/d" "$RC_FILE"
    sed -i "/ROUTER_USER/d" "$RC_FILE"
    sed -i "/ROUTER_PASSWORD/d" "$RC_FILE"
    cat << EOF >> "$RC_FILE"

# Настройки для скрипта управления VPN роутера
export ROUTER_HOST='$INPUT_HOST'
export ROUTER_USER='$INPUT_USER'
export ROUTER_PASSWORD='$INPUT_PASSWORD'
EOF
}

add_to_rc "$REAL_HOME/.bashrc"
add_to_rc "$REAL_HOME/.zshrc"

export ROUTER_HOST="$INPUT_HOST"
export ROUTER_USER="$INPUT_USER"
export ROUTER_PASSWORD="$INPUT_PASSWORD"