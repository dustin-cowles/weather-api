VAGRANTFILE_API_VERSION = "2"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # no vetting of this image was done for this exercise..
  config.vm.box = "saphyre/centos-8-puppet-x86_64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

  config.vm.network :private_network, ip: "10.0.0.100"
  config.vm.network :forwarded_port, guest: 80, host: 8080

  config.vm.synced_folder "weather_api", "/var/www/weather_api"

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "weather_api.pp"
    puppet.module_path = "puppet/modules"
  end
end
