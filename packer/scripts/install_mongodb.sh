#!/bin/bash
export DEBIAN_FRONTEND=noninteractive;
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
apt-get update -y
sleep 5
apt-get install -y mongodb-org
sleep 5
systemctl start mongod
systemctl enable mongod
