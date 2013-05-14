Vagrant.configure("2") do |config|
    config.vm.box = "precise32"
    config.vm.network :private_network, ip: "33.33.33.10"
    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.box_url = "http://files.vagrantup.com/precise32.box"
    config.vm.synced_folder "../../", "/vagrant"
    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.manifest_file  = "site.pp"
        puppet.options = "--verbose"
    end
end