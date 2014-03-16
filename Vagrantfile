Vagrant.configure("2") do |config|


    config.vm.define "devbox" do |devbox|


      devbox.vm.box = "hashicorp/precise64"


      devbox.vm.provider "virtualbox" do |v|
        devbox.vm.network :private_network, ip: "33.33.33.10"      
        v.customize ["modifyvm", :id, "--memory", 2048]
        v.customize ["modifyvm", :id, "--cpus", 2]
        v.customize ["modifyvm", :id, "--cpuexecutioncap", 95]
      end

      devbox.vm.provider "vmware_fusion" do |v|
          devbox.vm.network :private_network, ip: "33.33.31.10"                
          v.vmx["memsize"] = "2048"
          v.vmx["numvcpus"] = "2"
      end

      # apache nginx is listening on 80
      devbox.vm.network :forwarded_port, guest: 80, host: 8080


      #xdebug
      devbox.vm.network :forwarded_port, guest: 9001, host: 9001



      ###############
      ## nfs shares #
      ###############

      devbox.vm.synced_folder "../", "/vagrant" #, :nfs => true
      
      # https://coderwall.com/p/p3bj2a
      devbox.ssh.forward_agent = true

      devbox.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.manifest_file  = "site.pp"
        puppet.options = "--verbose"
      end

      # set the image name
      devbox.vm.define :devbox do |t|
      end

      devbox.vbguest.no_remote = true

      # comment this out if you want to debug the vagrant setup and speed up booting an empty box
      #config.vbguest.auto_update = false

    end
end
