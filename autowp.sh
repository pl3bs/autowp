#install nginx & php

apt-get install nginx php5-fpm php5-mysql php5-gd libssh2-php -y;

#install mysql automagically

apt-get update;
read -p "Enter MySQL Root Password " sqlr;
echo mysql-server mysql-server/root_password password "$sqlr" | sudo debconf-set-selections;
echo mysql-server mysql-server/root_password_again password "$sqlr" | sudo debconf-set-selections;
apt-get install mysql-server -y;
sudo mysql_install_db;
printf "%s\n%s\n\nn\nY\nY\nY\nY" "$sqlr" | mysql_secure_installation;
read -p "Enter Wordpress Database User " user;
printf "CREATE DATABASE wordpress;\nCREATE USER wordpressuser@localhost IDENTIFIED BY '%s';\nGRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost;\nFLUSH PRIVILEGES;\nexit; "$user" | mysql -u root --password="$sqlr";


#get wordpress

wget http://wordpress.org/latest.tar.gz;
tar xzvf latest.tar.gz;
cd wordpress;
cp wp-config-sample.php wp-config.php;
sed -i "/^define('DB_NAME'/ s/database_name_here');$/wordpress');/g" wp-config.php;
sed -i "/^define('DB_USER'/ s/username_here');$/wordpressuser');/g" wp-config.php;
sed -i "/^define('DB_PASSWORD'/ s/password_here');$/"$user"');/g" wp-config.php;

mkdir /var/www/wordpress;
sudo rsync -avP ~/wordpress/ /var/www/html/;
mkdir /var/www/wordpress/uploads;
sudo chown -R www-data:www-data /var/www/wordpress/*;
