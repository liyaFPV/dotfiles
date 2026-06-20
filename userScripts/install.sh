#!/bin/bash

echo "=== Скрипт настройки и установки зависимостей ==="
echo ""

echo "[1/3] Установка пакетов expect и telnet через sudo..."
sudo apt-get update && sudo apt-get install -y expect telnet

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
echo "[3/3] Сохранение переменных в ~/.bashrc..."

REAL_USER=${SUDO_USER:-$USER}
if [ "$REAL_USER" = "root" ]; then
    BASHRC_PATH="/root/.bashrc"
else
    BASHRC_PATH="/home/$REAL_USER/.bashrc"
fi

touch "$BASHRC_PATH"

sed -i "/ROUTER_HOST/d" "$BASHRC_PATH"
sed -i "/ROUTER_USER/d" "$BASHRC_PATH"
sed -i "/ROUTER_PASSWORD/d" "$BASHRC_PATH"

cat << EOF >> "$BASHRC_PATH"

# Настройки для скрипта управления VPN роутера
export ROUTER_HOST='$INPUT_HOST'
export ROUTER_USER='$INPUT_USER'
export ROUTER_PASSWORD='$INPUT_PASSWORD'
EOF

export ROUTER_HOST="$INPUT_HOST"
export ROUTER_USER="$INPUT_USER"
export ROUTER_PASSWORD="$INPUT_PASSWORD"