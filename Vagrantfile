VAGRANTFILE_API_VERSION = "2"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # no vetting of this image was done for this exercise..
  config.vm.box = "saphyre/centos-8-puppet-x86_64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

  config.vm.network :private_network, ip: "10.0.0.100"
  config.vm.network :forwarded_port, guest: 80, host: 8080

  # I need to find a way to get rid of these hacks because they are not good
  # and also prevent the use of `vagrant reload --provision`
  # Adding the www-data user and group here with specific uid/gid
  config.vm.provision "shell", inline: "groupadd -g 1011 www-data && useradd -r -u 1011 -g www-data www-data"
  # I was having difficulty getting puppet-selinux module to download with
  # `puppet apply` as triggered by Vagrant so I am disabling selinux here
  config.vm.provision "shell", inline: "setenforce 0"
  config.vm.synced_folder "weather_api", "/var/www/weather_api", owner: 1011, group: 1011

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "nodes.pp"
    puppet.module_path = "puppet/modules"
  end
end
