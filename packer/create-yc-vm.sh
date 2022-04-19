#!/bin/bash
image_name=`cat variables.json | grep -oP '(?<="image_name_immutable":")[^"]*'`
yc compute instance create --name reddit-app --hostname reddit-app --zone ru-central1-a --create-boot-disk name=disk1,size=10,image-name=$image_name --public-ip --ssh-key ~/.ssh/yc-user.pub
