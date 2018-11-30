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

Applies https://github.com/systemd/systemd/issues/3423

postinstall.sh works again (despite one warning: ==> virtualbox-iso: Provisioning with shell script: scripts/postinstall.sh
    virtualbox-iso: ++ which nixos-enter
    virtualbox-iso: + /run/current-system/sw/bin/nixos-enter --root /
    virtualbox-iso: setting up /etc...
    virtualbox-iso: WARNING: bad ownership on /nix/var/nix/profiles/per-user/vagrant, should be 0)

ls -la /home/vagrant/.nix-channels /home/vagrant/.cache is root jeweils (du to nix-enter above??): https://www.vagrantup.com/docs/synced-folders/basic_usage.html#mount_options
After "fix" warning "virtualbox-iso: WARNING: bad ownership on /nix/var/nix/profiles/per-user/vagrant, should be 0)" persists
	Siehe bspw. boot.sh:
	mkfs.ext4 -j -L nixos /dev/sda1
	mount LABEL=nixos /mnt
	# Generate hardware config.
	nixos-generate-config --root /mnt
When using $(which nix-enter) ... -- nix-commands ... form getting:
virtualbox-iso: ++ which nixos-enter
    virtualbox-iso: + /run/current-system/sw/bin/nixos-enter --root / -- nixos-rebuild switch --upgrade
    virtualbox-iso: setting up /etc...
    virtualbox-iso: unpacking channels...
    virtualbox-iso: warning: Nix search path entry '/nix/var/nix/profiles/per-user/root/channels/nixos' does not exist, ignoring
    virtualbox-iso: error: file 'nixpkgs/nixos' was not found in the Nix search path (add it using $NIX_PATH or -I), at (string):1:13
    virtualbox-iso: Failed to connect to bus: No data available
    virtualbox-iso: building Nix...
    virtualbox-iso: warning: Nix search path entry '/nix/var/nix/profiles/per-user/root/channels/nixos' does not exist, ignoring
    virtualbox-iso: error: file 'nixpkgs/nixos' was not found in the Nix search path (add it using $NIX_PATH or -I)
    virtualbox-iso: warning: Nix search path entry '/nix/var/nix/profiles/per-user/root/channels/nixos' does not exist, ignoring
    virtualbox-iso: error: file 'nixpkgs' was not found in the Nix search path (add it using $NIX_PATH or -I)
    virtualbox-iso: these paths will be fetched (15.16 MiB download, 65.00 MiB unpacked):
    virtualbox-iso:   /nix/store/12zhmzzhrwszdc8q3fwgifpwjkwi3mzc-gcc-7.3.0-lib

https://github.com/NixOS/nixpkgs/issues/40165 has some info on it (https://www.google.com/search?q=nixos+rebuild+switch+Nix+search+path+entry+%27%2Fnix%2Fvar%2Fnix%2Fprofiles%2Fper-user%2Froot%2Fchannels%2Fnixos%27+does+not+exist )

Could test: "On linux install nfs-kernel-server" (from Vagrantfile)

Issue "A start job is running for udev (...) / 3 min)
(...)
(...) systemctl status systemd-udev-settle.service"

Try # systemctl mask systemd-udev-settle (https://bbs.archlinux.org/viewtopic.php?id=189106)

Is no clean solution though, try that https://stackoverflow.com/questions/23371594/systemd-udev-dependency-failure-when-auto-mounting-separate-partition-during-sta
* journalctl -b:
Nov 02 10:09:34 nixbox systemd-udevd[398]: seq 946 '/devices/pci0000:00/0000:00>Nov 02 10:09:34 nixbox systemd-udevd[398]: seq 952 '/devices/pci0000:00/0000:00>Nov 02 10:09:34 nixbox systemd-udevd[398]: seq 950 '/devices/pci0000:00/0000:00>Nov 02 10:09:34 nixbox systemd-udevd[398]: seq 947 '/devices/pci0000:00/0000:00>Nov 02 10:10:50 nixbox systemd[1]: systemd-udev-settle.service: Main process ex>Nov 02 10:10:50 nixbox systemd[1]: systemd-udev-settle.service: Failed with res>Nov 02 10:10:50 nixbox systemd[1]: Failed to start udev Wait for Complete Devic>Nov 02 10:11:00 nixbox audit[1]: SERVICE_START pid=1 uid=0 auid=4294967295 ses=>Nov 02 10:11:00 nixbox kernel: kauditd_printk_skb: 150 callbacks suppressed
Nov 02 10:11:00 nixbox kernel: audit: type=1130 audit(1541153460.671:65): pid=1>Nov 02 10:11:00 nixbox systemd[1]: Reached target System Initialization.
* systemd-analyze blame:
    2min 18.001s systemd-udev-settle.service
* systemctl status -l systemd-udev-settle.service:
● systemd-udev-settle.service - udev Wait for Complete Device Initialization
   Loaded: loaded (/nix/store/h3pzqhlqsfh3vads4f0m8abp6pjr45jx-systemd-239/exam>   Active: failed (Result: exit-code) since Fri 2018-11-02 10:10:50 UTC; 13min >     Docs: man:udev(7)
           man:systemd-udevd.service(8)
  Process: 407 ExecStart=/nix/store/h3pzqhlqsfh3vads4f0m8abp6pjr45jx-systemd-23> Main PID: 407 (code=exited, status=1/FAILURE)

Nov 02 10:08:32 nixbox systemd[1]: Starting udev Wait for Complete Device Initi>Nov 02 10:10:50 nixbox systemd[1]: systemd-udev-settle.service: Main process ex>Nov 02 10:10:50 nixbox systemd[1]: systemd-udev-settle.service: Failed with res>Nov 02 10:10:50 nixbox systemd[1]: Failed to start udev Wait for Complete Devic>lines 1-12/12 (END)
Disabled it for now.

There are issues with systemd-udevd though, but it comes up at least:
● systemd-udevd.service - udev Kernel Device Manager
   Loaded: loaded (/nix/store/h3pzqhlqsfh3vads4f0m8abp6pjr45jx-systemd-239/exam>  Drop-In: /nix/store/rkh9qisy97h1x59hmr740dpiahj67gda-system-units/systemd-ude>           └─overrides.conf
   Active: active (running) since Fri 2018-11-02 10:54:13 UTC; 6min ago
     Docs: man:systemd-udevd.service(8)
           man:udev(7)
 Main PID: 391 (systemd-udevd)
   Status: "Processing with 10 children at max"
    Tasks: 1
   Memory: 13.9M
   CGroup: /system.slice/systemd-udevd.service
           └─391 /nix/store/h3pzqhlqsfh3vads4f0m8abp6pjr45jx-systemd-239/lib/sy>
Nov 02 10:57:17 nixbox systemd-udevd[391]: seq 946 '/devices/pci0000:00/0000:00>Nov 02 10:57:17 nixbox systemd-udevd[391]: seq 952 '/devices/pci0000:00/0000:00>Nov 02 10:57:17 nixbox systemd-udevd[391]: worker [487] terminated by signal 9 >Nov 02 10:57:17 nixbox systemd-udevd[391]: worker [487] failed while handling '>Nov 02 10:57:32 nixbox systemd-udevd[391]: worker [413] terminated by signal 9 >Nov 02 10:57:32 nixbox systemd-udevd[391]: worker [413] failed while handling '>Nov 02 10:57:32 nixbox systemd-udevd[391]: worker [414] terminated by signal 9 >Nov 02 10:57:32 nixbox systemd-udevd[391]: worker [414] failed while handling '>Nov 02 10:57:33 nixbox systemd-udevd[391]: worker [415] terminated by signal 9 >lines 1-23/24 93%

What also doesn't work yet is the host folder mount at /vagrant.

NixOps will probably shine in comarison with the hack needed to make the vbox shared folder work, which basically seems to be adding configuration.nix entries in the postinstall.sh script only.

virtualbox-iso: A dependency job for local-fs.target failed. See 'journalctl -xe' for details.

$ nix repl
> c = import <nixpkgs/nixos> {}
> c.config.fileSystems."/mnt"