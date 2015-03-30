cd /tmp;
wget http://wordpress.org/latest.tar.gz;
tar xzvf latest.tar.gz;
cd wordpress;
read -p "Enter Wordpress User Database Password " pwd;
cp wp-config-sample.php wp-config.php;
sed -i "/^define('DB_NAME'/ s/database_name_here');$/wordpress');/g" wp-config.php;
sed -i "/^define('DB_USER'/ s/username_here');$/wordpressuser');/g" wp-config.php;
sed -i "/^define('DB_PASSWORD'/ s/password_here');$/"$pwd");/g" wp-config.php;
mkdir /var/www/wordpress;
sudo rsync -avP /tmp/wordpress/ /var/www/wordpress;
mkdir /var/www/wordpress/uploads;
sudo chown -R www-data:www-data /var/www/wordpress/;


#install LAMP
cd /tmp;
apt-get update;
apt-get install apache2 libapache2-mod-php5 php5-mysql -y;

#configure nginx for wordpress

#wget https://raw.githubusercontent.com/pl3bs/autowp/master/apache-proxy.conf;
#mv apache-proxy.conf /etc/nginx/conf.d/apache-proxy.conf;
#rm /etc/nginx/sites-available/default;

#install mysql automagically

read -p "Enter MySQL Root Password " sqlr;
read -p "Enter Wordpress Database User " user;
echo mysql-server mysql-server/root_password password "$sqlr" | sudo debconf-set-selections;
echo mysql-server mysql-server/root_password_again password "$sqlr" | sudo debconf-set-selections;
apt-get install mysql-server -y;
sudo mysql_install_db;
printf "%s%s\nn\nY\nY\nY\nY" "$sqlr" | mysql_secure_installation;
printf "CREATE DATABASE wordpress;\nCREATE USER wordpressuser@localhost IDENTIFIED BY '%s';\nGRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost;\nFLUSH PRIVILEGES;\nexit" "$user" | mysql -u root --password="$sqlr";


