#!/bin/bash

## Info
echo -n "Installing all updates, this may take a few minutes ......";
apt-get update -y ;

## Install NFS
echo -n "Installing NFS ......";
apt-get install nfs-kernel-server -y


## NFS Folders
echo -n "Creating/Adjusting Folder /mysql & /html and editing /etc/exports ......";

mkdir /{mysql,html} >/dev/null 2>&1
chmod -R 755 /{mysql,html}
chown nobody:nogroup {/mysql,/html}


echo "/ *(rw,sync,no_root_squash,no_all_squash)" >> /etc/exports

## Restart Services
echo -n "Restarting Services ......";
service nfs-kernel-server restart
