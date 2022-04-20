#!/bin/bash
mkdir -p /home/$UNAME/reddit
git clone -b monolith https://github.com/express42/reddit.git /home/$UNAME/reddit
cd /home/$UNAME/reddit && sudo bundle install
