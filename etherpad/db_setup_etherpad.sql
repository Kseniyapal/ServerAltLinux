CREATE DATABASE etherpad;
GRANT ALL PRIVILEGES ON etherpad.* to etherpad@localhost IDENTIFIED BY '@psswd';
ALTER DATABASE etherpad CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
FLUSH PRIVILEGES;
