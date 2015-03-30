sudo apt-get update;
echo | sudo apt-get install nginx mysql-server php5-fpm php5-mysql -y;
sudo mysql_install_db;
sudo mysql_secure_installation;
