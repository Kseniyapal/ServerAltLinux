#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 db_password usr_psswd"
  exit 1
fi

# Создание установочных файлов
sed -e "s/@psswd/$2/g" db_setup_etherpad.sql > db_setup_etherpad_with_arg.sql
sed -e "s/@psswd/$2/g" param_settings.json > settings.json

# Создание базы данных для приложения
mysql -u root -p"$1" < db_setup_etherpad_with_arg.sql

# Обновление пакетов
apt-get update

# Установка зависимостей
apt-get install gnupg2 git unzip libssl-devel pkg-config gcc gpp make build-essential -y
apt-get install nodejs -y

# Создание пользователя
adduser --home /opt/etherpad --shell /bin/bash etherpad
install -d -m 755 -o etherpad -g etherpad /opt/etherpad

# Установка Etherpad
su - etherpad -c "wget https://github.com/ether/etherpad-lite/archive/refs/tags/v1.9.0.tar.gz -O etherpad.tar.gz"
su - etherpad -c "tar -xvf etherpad.tar.gz && mv etherpad-lite-1.9.0 etherpad-lite"
mv settings.json /opt/etherpad/etherpad-lite/
chown etherpad:etherpad /opt/etherpad/etherpad-lite/settings.json
su - etherpad -c "/opt/etherpad/etherpad-lite/bin/installDeps.sh"
mv etherpad.service /etc/systemd/system/

# Запуск и включение автозагрузки Etherpad
systemctl daemon-reload
systemctl enable etherpad.service
systemctl start etherpad.service

echo "Установка Etherpad завершена!"
