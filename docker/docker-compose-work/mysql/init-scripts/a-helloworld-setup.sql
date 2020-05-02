-- CREATE USER 'hello_user'@'localhost' IDENTIFIED BY 'password';
CREATE DATABASE IF NOT EXISTS helloworld;
ALTER DATABASE helloworld DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- GRANT ALL PRIVILEGES ON helloworld.* TO 'hello_user@%' IDENTIFIED BY 'hello_user';
