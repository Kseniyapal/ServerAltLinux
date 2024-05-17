## Инструкция к скрипту установки приложения: Etherpad

Сценарий: Установка Etherpad на сервер с помощью скрипта `etherpad_install.sh`.

Целевая аудитория: Пользователи с базовыми знаниями Linux, желающие установить Etherpad на свой сервер.

Требования:

* Сервер с операционной системой Linux (SimplyLinux 10.2)
* Установленная база данных MySQL или MariaDB
* Доступ к учетной записи пользователя с правами администратора

### Возможный вариант установки базы данных MariaDB
Последующие команды рекомендуется выполнять от имени администратора

1. Установка MariaDB:
```
apt-get update
apt-get install mariadb-server mariadb-client -y
```

2. Запуск и включение автозагрузки MariaDB
```
systemctl enable mariadb.service
systemctl start mariadb.service
```

3. Безопасная установка MariaDB:
```
mysql_secure_installation
```

```
Enter current password for root (enter for none): Press the Enter
Enable unix_socket authentication? [Y/n]: n
Set root password? [Y/n]: Y
New password: Enter password
Re-enter new password: Repeat password
Remove anonymous users? [Y/n]: Y
Disallow root login remotely? [Y/n]: Y
Remove test database and access to it? [Y/n]:  Y
Reload privilege tables now? [Y/n]:  Y
```

### Установка приложения

1. Откройте терминал и выполните следующие команды по скачиванию установочных файлов:
```
git clone https://github.com/Kseniyapal/ServerAltLinux.git
```
```
cd ServerAltLinux
```

2. Перейдите в файл `/etc/my.cnf.d/server.cnf` с правами администратора и закомментируйте `skip-networking`

3. Перезапустите базу данных от имени администратора:
```
systemctl restart mariadb.service
```

4. Запуск скрипта от имени администратора:
```
chmod +x etherpad_install.sh
```
Необходимо передать 2 аргумента: Ваш пароль от базы данных, пароль пользователя `etherpad` от базы данных.
```
./etherpad_install.sh arg1 arg2
```

### Завершение:
* После установки зависимостей скрипт выведет сообщение о готовности к эксплуатации приложения.
* URL: http://localhost:9001/

### Сохранение прогресса работы приложения:
```
chmod +x dump_etherpad_data_script.sh
```
Необходимо передать 2 аргумента: Ваш пароль от базы данных, абсолютный путь до директории включительно.
```
./dump_etherpad_data_script.sh arg1 arg2
```

### Восстановление предыдущего состояния базы данных:
```
chmod +x recovery_etherpad_data_script.sh
```
Необходимо передать 2 аргумента: Ваш пароль от базы данных, абсолютный путь до файла включительно, где хранится нужное Вам состояние базы данных.
```
./recovery_etherpad_data_script.sh arg1 arg2
```
