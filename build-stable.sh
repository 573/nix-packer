#!/bin/sh

url=$(curl -LsI -o /dev/null -w %{url_effective} https://d3g5gsiof5omrk.cloudfront.net/nixos/18.09/nixos-18.09.892.c06f5302f63/nixos-minimal-18.09.892.c06f5302f63-x86_64-linux.iso)
chksum=$(curl "$url".sha256)

wget --no-check-certificate -c --no-clobber 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -P keys
wget --no-check-certificate -c --no-clobber 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant' -P keys -O keys/vagrant.key

#packer build -var "iso_url=$url" -var "iso_checksum=$chksum" "$@" nixos-stable-x86_64.json
packer build -var "disk_size=50000" "$@" nixos-stable-x86_64.json
