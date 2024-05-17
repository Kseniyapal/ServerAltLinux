#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 db_psswd usr-psswd"
  exit 1
fi

# Создание установочного файла
sed -e "s/@psswd/$2/g" db_setup_invoiceninja.sql > db_setup_invoiceninja_with_arg.sql

# Создание базы данных для приложения
mysql -u root -p"$1" < db_setup_invoiceninja_with_arg.sql

# Обновление пакетов
apt-get update

# Установка Apache и PHP
apt-get install apache2 apache2-httpd-prefork apache2-mod_ssl -y
apt-get install php8.1 apache2-mod_php8.1 php8.1-gmp php8.1-curl php8.1-intl php8.1-mbstring php8.1-xmlreader php8.1-xmlrpc php8.1-gd php8.1-zip php8.1-mysqli php8.1-openssl php8.1-sodium php8.1-fileinfo php8.1-pdo php8.1-fpm-fcgi php8.1-pdo_mysql -y

# Установка дополнительных зависимостей
apt-get install git -y

# Запуск и включение автозагрузки Apache
systemctl enable httpd2.service
systemctl start httpd2.service

# Конфигурация PHP
sed -i 's/;file_uploads = Off/file_uploads = On/' /etc/php/8.1/cli/php.ini
sed -i 's/;allow_url_fopen = Off/allow_url_fopen = On/' /etc/php/8.1/cli/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 256M/' /etc/php/8.1/cli/php.ini
sed -i 's/upload_max_filesize = 20M/upload_max_filesize = 100M/' /etc/php/8.1/cli/php.ini
sed -i 's/;date.timezone =/date.timezone = Russia\/Moscow/' /etc/php/8.1/cli/php.ini
sed -i 's/;short_open_tag = Off/short_open_tag = On/' /etc/php/8.1/cli/php.ini
sed -i 's/max_execution_time = 240/max_execution_time = 360/' /etc/php/8.1/cli/php.ini

# Запуск и включение автозагрузки PHP
systemctl enable php8.1-fpm.service
systemctl start php8.1-fpm.service

# Установка Invoice Ninja
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
wget https://github.com/invoiceninja/invoiceninja/archive/refs/tags/v5.7.6.tar.gz -O invoiceninja.tar.gz
tar -xvf invoiceninja.tar.gz
mv invoiceninja-5.7.6 /var/www/html/invoiceninja
mv invoiceninja.conf /etc/httpd2/conf/sites-available/
cd /var/www/html/invoiceninja

COMPOSER_ALLOW_SUPERUSER=1 composer install -n

chown -R apache2:apache2 /var/www/html/invoiceninja
chmod -R 755 /var/www/html/invoiceninja/

if ! grep "<Directory />" "/etc/httpd2/conf/httpd2.conf"; then
    sed -i "/<\/IfModule>/a <Directory />\n    AllowOverride ALL\n</Directory>" /etc/httpd2/conf/httpd2.conf
fi

cp .env.example .env

sed -i 's/DB_DATABASE=ninja/DB_DATABASE=invoiceninja/' .env
sed -i 's/DB_USERNAME=ninja/DB_USERNAME=invoiceninjauser/' .env
sed -i "s/DB_PASSWORD=ninja/DB_PASSWORD=$2/" .env

/usr/sbin/a2ensite invoiceninja
/usr/sbin/a2enmod rewrite

# Перезапуск Apache
systemctl restart httpd2.service

echo "Установка Invoice Ninja завершена!"
