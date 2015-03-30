#install mysql

apt-get update;
read -p "Enter MySQL Root Password " psss;
echo mysql-server mysql-server/root_password password Y | sudo debconf-set-selections;
echo mysql-server mysql-server/root_password_again password Y | sudo debconf-set-selections;
apt-get install mysql-server -y;
sudo mysql_install_db;
yes Y | mysql_secure_installation;
yes Y | mysql -u root -p;





#install nginx & php
#apt-get install nginx php5-fpm php5-mysql -y;
