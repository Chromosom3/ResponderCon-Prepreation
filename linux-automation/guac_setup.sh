#!/usr/bin/env bash

# Script: guac_setup.sh
# Author: Dylan 'Chromosome' Navarro
# Description: Builds guacamole server version 1.4.0 as of September 1st, 2022. This is intended to be run as root.

# Guacamole Server
apt install build-essential libcairo2-dev libjpeg-turbo8-dev \
    libpng-dev libtool-bin libossp-uuid-dev libvncserver-dev \
    freerdp2-dev libssh2-1-dev libtelnet-dev libwebsockets-dev \
    libpulse-dev libvorbis-dev libwebp-dev libssl-dev \
    libpango1.0-dev libswscale-dev libavcodec-dev libavutil-dev \
    libavformat-dev -y
cd ~
wget https://downloads.apache.org/guacamole/1.4.0/source/guacamole-server-1.4.0.tar.gz
tar -xvf guacamole-server-1.4.0.tar.gz
cd guacamole-server-1.4.0
CFLAGS=-Wno-error ./configure --with-init-dir=/etc/init.d --enable-allow-freerdp-snapshots
make
make install
ldconfig
systemctl daemon-reload
systemctl start guacd
systemctl enable guacd
mkdir -p /etc/guacamole/{extensions,lib}

# Guacamole Web Client
apt install tomcat9 tomcat9-admin tomcat9-common tomcat9-user -y
cd ~
wget https://dlcdn.apache.org/guacamole/1.4.0/binary/guacamole-1.4.0.war
mv guacamole-1.4.0.war /var/lib/tomcat9/webapps/guacamole.war
systemctl restart tomcat9 guacd

# Backend DB for the Web Client
apt install mariadb-server -y
cd ~ 
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.26.tar.gz
tar -xf mysql-connector-java-8.0.26.tar.gz
cp mysql-connector-java-8.0.26/mysql-connector-java-8.0.26.jar /etc/guacamole/lib/
wget https://dlcdn.apache.org/guacamole/1.4.0/binary/guacamole-auth-jdbc-1.4.0.tar.gz
tar -xf guacamole-auth-jdbc-1.4.0.tar.gz
mv guacamole-auth-jdbc-1.4.0/mysql/guacamole-auth-jdbc-mysql-1.4.0.jar /etc/guacamole/extensions/
#Database commands
read -p "You must set a mysql root password: " SQL_ROOT_PASS
read -p "You must set a password for the guac_user account: " SQL_GUAC_PASS
# MySQL is broken
mysql -u root <<-EOF
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$SQL_ROOT_PASS');
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
CREATE DATABASE guacamole_db;
CREATE USER 'guacamole_user'@'localhost' IDENTIFIED BY '$SQL_GUAC_PASS';
GRANT SELECT,INSERT,UPDATE,DELETE ON guacamole_db.* TO 'guacamole_user'@'localhost';
FLUSH PRIVILEGES;
EOF
# End of DB commands
cd guacamole-auth-jdbc-1.4.0/mysql/schema
# Should remove the hard coded guacamole_db database name and change to a variable.
cat *.sql | mysql -u root -p guacamole_db
# Backend LDAP connection for the webclient
cd ~
wget https://dlcdn.apache.org/guacamole/1.4.0/binary/guacamole-auth-ldap-1.4.0.tar.gz
tar -xf guacamole-auth-ldap-1.4.0.tar.gz
sudo cp guacamole-auth-ldap-1.4.0/guacamole-auth-ldap-1.4.0.jar /etc/guacamole/extensions/

# Get some values for the LDAP settings
read -p "LDAP Hostname: " LDAP_HOSTNAME
read -p "LDAP DN: " LDAP_DN
read -p "LDAP User: " LDAP_USER
read -p "LDAP Password: " LDAP_PASSWORD

# Guacamole Configuration File
echo "# MySQL properties
mysql-hostname: 127.0.0.1
mysql-port: 3306
mysql-database: guacamole_db
mysql-username: guacamole_user
mysql-password: $SQL_GUAC_PASS

# LDAP properties
ldap-hostname:           $LDAP_HOSTNAME
ldap-port:               389
ldap-user-base-dn:       $LDAP_DN
ldap-username-attribute: samAccountName
ldap-config-base-dn:     $LDAP_DN
ldap-encryption-method:  none
ldap-search-bind-dn:$LDAP_USER
ldap-search-bind-password:$LDAP_PASSWORD
" > /etc/guacamole/guacamole.properties

# All Done... lets restart some services to apply settings
systemctl restart tomcat9 guacd mysql
