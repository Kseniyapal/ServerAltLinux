## Инструкция к скрипту установки приложения: Invoice Ninja
Сценарий: Установка Invoice Ninja на сервер с помощью скрипта `invoiceninja_install.sh`.

Целевая аудитория: Пользователи с базовыми знаниями Linux, желающие установить Invoice Ninja на свой сервер.

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

1. Откройте терминал и выполните следующие команды по скачиванию и распаковке установочных файлов:
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
chmod +x invoiceninja_install.sh
```
Необходимо передать 2 аргумента: Ваш пароль от базы данных, пароль пользователя `invoiceninjauser` от базы данных.
```
./invoiceninja_install.sh arg1 arg2
```

### Завершение:
* После успешной установки скрипт выведет сообщение о готовности к эксплуатации приложения.
* URL: http://localhost:80/setup/

### Сохранение прогресса работы приложения:
```
chmod +x dump_invoiceninja_data_script.sh
```
Необходимо передать 2 аргумента: Ваш пароль от базы данных, абсолютный путь до директории включительно.
```
./dump_invoiceninja_data_script.sh arg1 arg2
```

### Восстановление предыдущего состояния базы данных:
```
chmod +x recovery_invoiceninja_data_script.sh
```
Необходимо передать 2 аргумента: Ваш пароль от базы данных, абсолютный путь до файла включительно, где хранится нужное Вам состояние базы данных.
```
./recovery_invoiceninja_data_script.sh arg1 arg2
```

### Донастройка приложения:
![Пример](/invoiceninja/screenshots/invoiceninja1.png)
![Пример](/invoiceninja/screenshots/invoiceninja2.png)
![Пример](/invoiceninja/screenshots/invoiceninja3.png)
![Пример](/invoiceninja/screenshots/invoiceninja4.png)
![Пример](/invoiceninja/screenshots/invoiceninja5.png)
![Пример](/invoiceninja/screenshots/invoiceninja6.png)
