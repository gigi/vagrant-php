# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder "/srv/utils", "/srv/utils"
  config.vm.synced_folder "/srv/www", "/srv/www",
	id: "vagrant-www",
	type: "nfs"
	# owner: "www-data", group: "www-data", type: "nfs"
  config.vm.synced_folder "/srv/nginx", "/srv/nginx"
  config.vm.synced_folder "/srv/mysql", "/srv/mysql",
    mount_options: ["dmode=777","fmode=777"]
    # id: "mysql", owner: "mysql", group: "mysql", 
    # waiting for mount after provision feature
    # https://github.com/mitchellh/vagrant/issues/936

  config.vm.network "private_network", ip: "192.168.33.33"

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
  end
	
  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.provision :shell, :inline => "sudo service nginx restart", run: "always"
  config.vm.provision :shell, :inline => "sudo service mysql restart", run: "always"
end
