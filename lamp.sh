#!/bin/bash
# by Brett Garman
# Intended use: Ubuntu Server 18
#
# find your server's ip address: ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//' 
# 
# To execute this script use: wget -O -https://github.com/Blockyard-Code/blockyard-lamp.git  | bash 
if [ "`lsb_release -is`" == "Ubuntu" ] || [ "`lsb_release -is`" == "Debian" ]
then
    sudo apt update && sudo apt upgrade;
#webserver
    sudo apt install apache2;
#database
    sudo apt install mysql-server; #mysql-client mysql-workbench libmysqld-dev;
#remove dangerous security issues and lock down system, choose yes for everything except the secure password thing
    sudo mysql_secure_installation;
#coding language for wordpress and others
    sudo apt install php libapache2-mod-php;
        #(another possible option)sudo apt install php7.2-fpm php7.2-common php7.2-mysql php7.2-gmp php7.2-curl php7.2-intl php7.2-mbstring php7.2-xmlrpc php7.2-gd php7.2-bcmath php7.2-xml php7.2-cli php7.2-zip
#install phpmyadmin
    sudo apt install phpmyadmin php-mbstring php-gettext;
#enable the mbstring configuration
    sudo phpenmod mbstring
#restart the web server
    sudo service apache2 restart;
#check the firewall has a profile with apache2
    sudo ufw app list
#check ports 80 and 443 are open in apache full app
    sudo ufw app info "Apache Full"
#allow http and https traffice
    sudo ufw allow in "Apache Full"
#restart the web server
    sudo service apache2 restart;

#optional install wordpress
    wget https://wordpress.org/latest.tar.gz
#unzip the package
    tar -xzvf latest.tar.gz

else
    echo "Unsupported Operating System";
fi
