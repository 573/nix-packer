# About

This is a [Packer](http://packer.io) definition for [NixOS](http://nixos.org). It
builds a [Vagrant](http://www.vagrantup.com/) box for NixOS 14.12
x86_64.

# Usage

(to be updated by cstrahan)

Pre-built boxes are [hosted on
VagrantCloud](https://vagrantcloud.com/cstrahan). To use a pre-built
box, you just need to set the `config.vm.box` setting in your
Vagrantfile to `"cstrahan/nixos-14.04-x86_64"`. Here's a complete
example:

``` ruby
Vagrant.configure("2") do |config|
  config.vm.box         = "cstrahan/nixos-14.04-x86_64"
  config.vm.box_version = "~> 0.1.0"

  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |v|
    v.memory = 4000
    v.gui = false
  end
end
```

# Building

If you want to customize the box, there are a couple
[variables](http://www.packer.io/docs/templates/user-variables.html) you can
pass to Packer:

* `swap_size` - The size of the swap partition in megabytes. If this is empty (the
  default), no swap partition is created.
* `disk_size` - The total size of the hard disk in megabytes (defaults
  to 2000).
* `graphical` - Set this to true to get a graphical desktop

There are also a couple variables that only affect the build:

* `memmory_size` - The amount of RAM in megabytes (defaults to 1024).
* `cpus` - The number of CPUs (defaults to 1).

Example:

``` bash
$ sh ./build-stable.sh    \
    -var 'cpus=2'         \
    -var 'swap_size=2000'
```

# Variants

https://github.com/nix-community/nixbox  
https://github.com/nix-community/vagrant-nixos-plugin  
https://github.com/sprotheroe/vagrant-disksize  

# Hacks

Added 18.09  

Ssh keys are retrieved (https://github.com/flomotlik/packer-example.git), even better would be smth like in https://github.com/nix-community/nixbox.

Deactivated some lines in scripts/postinstall.sh as that did not work out.

disksize plugin does not work, use disk_size parameter to packer.
