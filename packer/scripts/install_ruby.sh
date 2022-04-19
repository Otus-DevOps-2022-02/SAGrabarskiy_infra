#!/bin/bash
export DEBIAN_FRONTEND=noninteractive;
apt update
sleep 5
apt install -y ruby-full bundler ruby-bundler build-essential
