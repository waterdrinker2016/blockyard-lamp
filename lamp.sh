#!/bin/bash

if [ "`lsb_release -is`" == "Ubuntu" ] || [ "`lsb_release -is`" == "Debian" ]
then
    sudo apt update && sudo apt upgrade
#webserver
    sudo apt install apache2
#database
    sudo apt install mysql-server mysql-client mysql-workbench libmysqld-dev;
#remove dangerous security issues and lock down system
    sudo mysql_secure_installation
#coding language for wordpress and others
    sudo apt install php libapache2-mod-php php-mysql 
        #(another possible option)sudo apt install php7.2-fpm php7.2-common php7.2-mysql php7.2-gmp php7.2-curl php7.2-intl php7.2-mbstring php7.2-xmlrpc php7.2-gd php7.2-bcmath php7.2-xml php7.2-cli php7.2-zip
#restart the web server
    sudo service apache2 restart;

else
    echo "Unsupported Operating System";
fi
