#!/bin/bash

yum install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb

mysql -e "GRANT ALL ON *.* to '${mysql_username}'@'%' IDENTIFIED BY '${mysql_password}' WITH GRANT OPTION;"
