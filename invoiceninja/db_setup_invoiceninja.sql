CREATE DATABASE invoiceninja;
CREATE USER 'invoiceninjauser'@'localhost' IDENTIFIED BY '@psswd';
GRANT ALL ON invoiceninja.* TO 'invoiceninjauser'@'localhost' IDENTIFIED BY '@psswd' WITH GRANT OPTION;
FLUSH PRIVILEGES;
