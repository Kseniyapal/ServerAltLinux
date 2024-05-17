#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 db_psswd directory"
  exit 1
fi

# Создание каталога для сохранения копии, если он не существует
mkdir -p "$2"

# Получение текущей даты в формате ГГГГ-ММ-ДД
date=$(date +"%Y-%m-%d")

# Выполнение mysqldump и сохранение копии в файл
mysqldump -u root -p"$1" etherpad > "$2/dump_etherpad_data_$date.sql"

# Сообщение об успешном создании копии
echo "Копия базы данных успешно создана в файле " "$2/dump_etherpad_data_$date.sql"
