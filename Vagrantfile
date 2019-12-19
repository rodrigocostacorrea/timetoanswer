# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
	config.vm.provider "virtualbox"
	config.vm.box = "rodrigoit/dev-rails-5"
  	config.vm.box_version = "201912.0.1"

	config.vm.network :forwarded_port, guest: 3000, host: 3000 # rails
	config.vm.network :forwarded_port, guest: 3306, host: 3306 # mysql
	config.vm.boot_timeout = 600	
	
	#config.vbguest.auto_update = false	# set auto_update to false, if you do NOT want to check the correct additions version when booting this machine	
	#config.vbguest.no_remote = true # do NOT download the iso file from a webserver	  
	  
	config.vm.provider "virtualbox" do |vb|
		#vb.gui = true
		vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
		vb.customize [ "modifyvm", :id, "--cableconnected1", "on" ]
	end	
end
