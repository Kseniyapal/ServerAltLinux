#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 db_password file"
  exit 1
fi

# Получаем директорию текущего скрипта
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Проверка существования пользователя базы данных
USER_EXISTS=$(mysql -u root -p"$1" -e "SELECT User FROM mysql.user WHERE User='etherpad';" | grep etherpad)

# Проверка существования базы данных, если ее нет - создаем
DB_EXISTS=$(mysql -u root -p"$1" -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='etherpad';" | grep etherpad)
if [ -z "$DB_EXISTS" ] || [ -z "$USER_EXISTS" ]; then
  mysql -u root -p"$1" --force < "$SCRIPT_DIR/db_setup_etherpad_with_arg.sql"
fi

# Восстановление базы данных из копии
mysql -u root -p"$1" etherpad < "$2"

systemctl restart etherpad.service

# Сообщение об успешном восстановлении базы данных
echo "База данных успешно восстановлена из файла $2"
