#install mysql automagically

apt-get update;
read -p "Enter MySQL Root Password " psss;
echo mysql-server mysql-server/root_password password "$psss" | sudo debconf-set-selections;
echo mysql-server mysql-server/root_password_again password "$psss" | sudo debconf-set-selections;
apt-get install mysql-server -y;
sudo mysql_install_db;
printf "%s\n\nn\nY\nY\nY\nY'" "$psss" | mysql_secure_installation





#install nginx & php
#apt-get install nginx php5-fpm php5-mysql -y;
