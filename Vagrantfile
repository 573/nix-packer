# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box         = "nix-packer_machine"
  
  config.vm.network :private_network, ip: "192.168.50.5"
  config.vm.network :forwarded_port, guest: 5000, host: 5001
  config.vm.network :forwarded_port, guest: 22, host: 2259

  config.ssh.forward_agent = true
  
  # Forward X11
  config.ssh.forward_x11 = true

 ## Using NFS as it has much better performance
 ## On linux install nfs-kernel-server, MacOS works by default
 ## Will ask for root password to set some things up
 config.vm.synced_folder ".", "/vagrant", :nfs => true

  config.vm.provider "virtualbox" do |v|
    v.memory = 4000
    v.gui = false
  end
end
