#!/bin/bash
# by Brett Garman
# Intended use: Ubuntu Server 18.04 running on an EC2 instance
#
# find your server's ip address (if not ssh): ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//' 
# To execute this script use (not ready to work this way yet): wget -O -https://github.com/Blockyard-Code/blockyard-lamp.git  | bash 
#
# If creating an EC2 instance, you should assign an elastic ip and associate it 

if [ "`lsb_release -is`" == "Ubuntu" ] || [ "`lsb_release -is`" == "Debian" ]
then
#keep the version of grub that is currently installed
    sudo apt update && sudo apt upgrade;
#webserver
    sudo apt install apache2;
#start apache2 and check for default page using ip address
    sudo service apache2 start;
#database
    sudo apt install mysql-server; #mysql-client mysql-workbench libmysqld-dev;
#remove dangerous security issues and lock down system, choose yes for everything except the secure password thing
    sudo mysql_secure_installation;
######################################## create your admin account on mysql
#open mysql
#    sudo mysql
#add admin user 
#    GRANT ALL ON *.* TO 'yourNameHere'@'localhost' IDENTIFIED BY 'yourPasswordHere' WITH GRANT OPTION;
#enable the new data
#    flush privilages
#exit mysql
#    exit
######################################## create a wordpress database from the mysql shell:
#   mysql -u root -p
#   sign in using the admin account you created above
#   CREATE DATABASE wordpress CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
#   GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'change-with-strong-password';
#   flush privilages
#   exit
########################################
#restart the web server
    sudo service apache2 restart;
#change the priority of index.php, move it to first in the list and save
    sudo nano /etc/apache2/mods-enabled/dir.conf

#coding language install php7.3
    sudo apt install php libapache2-mod-php;
        #(another possible option if you need other packages) sudo apt install php-curl 
        #php-gd php-xml php-xmlrpc php-soap php-intl php-zip
#test to see if apache is talking to php
    sudo nano /var/www/html/info.php
#add the following to the info.php file and save (control X)
    <?php 
    phpinfo();
    ?>
#go to your_domain/info.php ...you should see a php table outlining all php settings
#now go back and delete that php function in nano
    sudo nano /var/www/html/info.php
#install phpmyadmin; you MUST use the space bar to select "apache2"
    sudo apt install phpmyadmin; 
#restart the web server
    sudo service apache2 restart;
#log into phpmyadmin with admin user you first created in mysql
#    yourIPaddress/phpmyadmin

#check the firewall has a profile with apache2
    sudo ufw app list;
#check ports 80 and 443 are open in apache full app
    sudo ufw app info "Apache Full";
#allow http and https traffic in not already ports 80/443 tcp
    sudo ufw allow in "Apache Full";
#restart the web server
    sudo service apache2 restart;

#install SSL certificate


#################################optional install wordpress

#change into writable directory
    cd .. #this will take you back to ubuntu in AWS 
    cd .. #this will take you back to home in AWS
    cd /tmp #this will put you into the root temp file
#install wordpress tarball
   curl -O https://wordpress.org/latest.tar.gz
#unzip the tarball
    tar -xzvf latest.tar.gz;
#create a dummy htaccess file for later use
    sudo touch wordpress/.htaccess
#create a wp-config.php based off of the sample
    sudo cp wordpress/wp-config-sample.php wordpress/wp-config.php
#create a upgrade directory to avoid permissions issues
    sudo mkdir wp-content/upgrade
#copy everything to document root. the dot indicates that this will even include hidden files like the .htaccess we created
    sudo cp -a wordpress/. /var/www/wordpress
#adjust ownership and permissions
    sudo chown -R www-data:www-data /var/www/wordpress
#set the correct permissions on wordpress directories and files, some plugins might require additional permissions
    sudo find /var/www/wordpress/ -type d -exec chmod 750 {} \;
    sudo find /var/www/wordpress/ -type f -exec chmod 640 {} \;
#change the wordpress config file using the wordpress secure key generator
    curl -s https://api.wordpress.org/secret-key/1.1/salt/
#copy the results from above then paste in the config file (must paste to text file, then copy from the text file in order to paste into nano)
    sudo nano /var/www/wordpress/wp-config.php #control X then yes to save and exit
#Modify the database connection settings in the wp-config file. 
#Set the method that WordPress should use to write to the filesystem. 
#Since we’ve given the web server permission to write where it needs to, we can explicitly set the filesystem 
    sudo nano /var/www/wordpress/wp-config.php
#change the following:    
    define('DB_NAME', 'wordpress');

    /** MySQL database username */
    define('DB_USER', 'wordpressuser');

    /** MySQL database password */
    define('DB_PASSWORD', 'password');

#add to the end of the wp-config file to allow for the filesystem to write without prompting for FTP creds.
    define('FS_METHOD', 'direct');
#restart the web server
    sudo service apache2 restart;

#open wordpress and start the web install

#restart the web server
    sudo service apache2 restart;
else
    echo "Unsupported Operating System";
fi
