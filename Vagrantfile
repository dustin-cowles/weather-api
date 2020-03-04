# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # I had issues with the CentOS 7 and 8 images. I will get
  # those working later, but for now I am using ubuntu.
  config.vm.box = "ubuntu/xenial64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

  config.vm.network :private_network, ip: "10.0.0.100"
  config.vm.network :forwarded_port, guest: 80, host: 8080

  config.vm.synced_folder "weather_caching/", "/var/www/weather", rsync: true

  config.vm.provision "shell", inline: "sudo apt-get update && sudo apt-get install -y puppet"
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "weather.pp"
  end
end
