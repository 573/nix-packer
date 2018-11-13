# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box         = "nix-packer_machine"
  
  config.vm.network :private_network, ip: "192.168.50.7"
  config.vm.network :forwarded_port, guest: 5000, host: 5003
  config.vm.network :forwarded_port, guest: 22, host: 2260

  config.ssh.forward_agent = true
  
  # Forward X11
  config.ssh.forward_x11 = true

 ## Using NFS as it has much better performance
 ## On linux install nfs-kernel-server, MacOS works by default
 ## Will ask for root password to set some things up
 config.vm.synced_folder ".", "/vagrant", :nfs => true, :owner => "vagrant", :group => "vagrant", mount_options: ["dmode=775","fmode=664"]

  config.vm.provider "virtualbox" do |v|
    v.memory = 4000
    v.gui = false
  end
end
