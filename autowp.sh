#install mysql automagically

apt-get update;
read -p "Enter MySQL Root Password " sqlr;
echo mysql-server mysql-server/root_password password "$sqlr" | sudo debconf-set-selections;
echo mysql-server mysql-server/root_password_again password "$sqlr" | sudo debconf-set-selections;
apt-get install mysql-server -y;
sudo mysql_install_db;
printf "%s\n\nn\nY\nY\nY\nY" "$sqlr" | mysql_secure_installation;
read -p "Enter Wordpress Database User " user;
printf "CREATE USER wordpressuser@localhost IDENTIFIED BY %s";\n "$user" | mysql -u root --password="$sqlr";






#install nginx & php
#apt-get install nginx php5-fpm php5-mysql -y;
