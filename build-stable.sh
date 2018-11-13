#!/bin/sh

url=$(curl -LsI -o /dev/null -w %{url_effective} https://d3g5gsiof5omrk.cloudfront.net/nixos/18.09/nixos-18.09.892.c06f5302f63/nixos-minimal-18.09.892.c06f5302f63-x86_64-linux.iso)
chksum=$(curl "$url".sha256 | awk -F' ' '{print $1;}')

curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -k --create-dirs -o keys/vagrant.pub
curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant -k --create-dirs -o keys/vagrant.key

packer build -var "disk_size=50000" -var "iso_checksum_type=sha256" -var "iso_url=$url" -var "iso_checksum=$chksum" "$@" nixos-stable-x86_64.json
