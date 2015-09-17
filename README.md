PHP5 + MySQL + Memcached

Overview
------------
Simple dev environment based on ubuntu/trusty64 using raw vagrant and linux bash scripts for provisioning. 

Features
------------
* Nginx vhosts on the host machine in /srv/nginx/sites-enabled folder
* MySQL data is persistent on the host machine in the /srv/mysql/data folder. So ```vagrant destroy``` won't remove Your databases
* Default folder for www content is /srv/www

Installation
------------
* [Install vagrant](https://docs.vagrantup.com/v2/installation/index.html)
* Clone this repository (or download this pack)
* Create folders /srv/nginx/sites-enabled, /srv/mysql, /srv/www, /srv/utils
* Run ```vagrant up```

Usage
------------
* To connect to mysql use host: 192.168.33.33, login: root, password: root
* To connect to memcache use host: 192.168.33.33, port: 11211

Installed components
--------------------
* [Nginx](http://nginx.org)
* [php-fpm](http://php-fpm.org)
* [MySQL](http://dev.mysql.com/downloads/mysql/)
* [Memcached](http://memcached.org/) + php5-memcache
* [Midnight Commander](https://www.midnight-commander.org/)

TODO
--------------------
* Use mkdir if dir not exists on the host
* Create default vhost if /srv/nginx/sites-enabled is empty
* Improve this readme :)