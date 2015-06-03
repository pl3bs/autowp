

cd /tmp;
wget --no-check-certificate http://wordpress.org/latest.tar.gz;
tar xzvf latest.tar.gz;
cd wordpress;
read -p "Enter MySQL Root Password " sqlr;
read -p "Enter Wordpress Domain Name (omit www.) " wp_domain;
read -p "Enter Wordpress Database Password " pwd;
cp wp-config-sample.php wp-config.php;
wp_sql=`echo "$wp_domain" | sed 's/\./_/g'`;
ring=`echo ${wp_sql: -12}`;

sed -i "/^define('DB_NAME'/ s/database_name_here');$/"$ring"');/g" wp-config.php;
sed -i "/^define('DB_USER'/ s/username_here');$/"$ring"user');/g" wp-config.php;
sed -i "/^define('DB_PASSWORD'/ s/password_here');$/"$pwd"');/g" wp-config.php;
sudo rsync -avP /tmp/wordpress/ /var/www/"$wp_domain"/;
mkdir /var/www/"$wp_domain"/uploads;
sudo chown -R www-data:www-data /var/www/;


#install LAMP
cd /tmp;
apt-get update;
apt-get install apache2 -y;
apt-get install nano php5 libapache2-mod-php5 php5-mcrypt php5-mysql php5-gd libssh2-php -y;
rm /var/www/html/index.html;

#configure nginx for wordpress

#wget https://raw.githubusercontent.com/pl3bs/autowp/master/apache-proxy.conf;
#mv apache-proxy.conf /etc/nginx/conf.d/apache-proxy.conf;
#rm /etc/nginx/sites-available/default;

#install mysql automagically

echo mysql-server mysql-server/root_password password "$sqlr" | sudo debconf-set-selections;
echo mysql-server mysql-server/root_password_again password "$sqlr" | sudo debconf-set-selections;
apt-get install mysql-server -y;
sudo mysql_install_db;
printf "%s%s\nn\nY\nY\nY\nY" "$sqlr" | mysql_secure_installation;
printf "CREATE DATABASE %s;\nCREATE USER %suser@localhost IDENTIFIED BY '%s';\nGRANT ALL PRIVILEGES ON %s.* TO %suser@localhost;\nFLUSH PRIVILEGES;\nexit" "$ring" "$ring" "$pwd" "$ring" "$ring" | mysql -u root --password="$sqlr";

#configure apache2

cd /etc/apache2/sites-available
wget https://raw.githubusercontent.com/pl3bs/autowp/master/apache-sample.conf
mv apache-sample.conf wp_"$wp_domain".conf
sed -i "/^        ServerName/ s/$/$wp_domain/g" wp_"$wp_domain".conf;
sed -i "/^        DocumentRoot/ s/$/$wp_domain/g" wp_"$wp_domain".conf;
a2dissite 000-default.conf;
a2ensite wp_"$wp_domain".conf;
service apache2 reload;

while [[ "$(read -p "Install Another Wordpress Site? [Y/n] " q;echo $q)" != "n" ]] ; do

        cd /tmp;
        wget https://raw.githubusercontent.com/pl3bs/autowp/testing/disc_autowp.sh;
        chmod +x disc_autowp.sh;
        ./disc_autowp.sh;
done
