#!/usr/bin/env bash

MYSQL_DATA_DIR="/srv/mysql/data"
MYSQL_PASSWORD="root"

NGINX_LOCATIONS_DIR="/srv/nginx/sites-enabled"

echo "Prepare repos…"
add-apt-repository -y ppa:nginx/stable

echo "Updating packages…"
apt-get update > /dev/null

echo "Installing MC…"
apt-get install -y mc > /dev/null
echo "Done!"

echo "Installing PHP…"
apt-get install -y php5-cli php5-common php5-memcache php5-mysql php5-fpm php-pear php5-mcrypt php5-curl > /dev/null
sed -i "s:short_open_tag = Off:#short_open_tag = On:" /etc/php5/fpm/php.ini
sed -i "s:short_open_tag = Off:#short_open_tag = On:" /etc/php5/cli/php.ini
service php5-fpm restart
echo "Done!"

echo "Installing Nginx…"
apt-get install -y nginx > /dev/null
echo "Configuring Nginx…"
rm -rf /etc/nginx/sites-enabled
ln -sfn $NGINX_LOCATIONS_DIR /etc/nginx
service nginx restart
echo "Done!"

echo "Installing Memcached"
apt-get install -y memcached > /dev/null
sed -i "s:-l:#-l:" /etc/memcached.conf
sed -i "s:-m 64:-m 512:" /etc/memcached.conf
service memcached restart
echo "Done!"

echo "Prepare MySQL…"

echo "Setting password prompts…"
apt-get install -y debconf-utils > /dev/null
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD"

echo "Updating apparmor…"
echo "alias /var/lib/mysql/ -> $MYSQL_DATA_DIR/mysql," | sudo tee -a /etc/apparmor.d/tunables/alias
/etc/init.d/apparmor restart

echo "Installing MySQL…" 
apt-get install -y mysql-server > /dev/null
echo "Updating mysql configs in /etc/mysql/my.cnf. …"
echo "Bind to 0.0.0.0"
sed -i "s:bind-address.*:bind-address = 0.0.0.0:" /etc/mysql/my.cnf
echo "MySQL datadir change"
if [ "$(ls -A $MYSQL_DATA_DIR)" ]; then
     echo "Mysql dir is not empty… Has data? Backup and remove if trouble"
else
    mv /var/lib/mysql $MYSQL_DATA_DIR
    echo "Datadir content copied to $MYSQL_DATA_DIR"
fi
sed -i "s:datadir.*:datadir = $MYSQL_DATA_DIR/mysql:g" /etc/mysql/my.cnf
echo "Root access to MySQL…"
mysql -u root -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p$MYSQL_PASSWORD mysql
service mysql restart
echo "Done!"
