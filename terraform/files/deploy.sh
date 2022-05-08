#!/bin/bash
APP_DIR=${1:-$HOME}
git clone -b monolith https://github.com/express42/reddit.git $APP_DIR/reddit
cd $APP_DIR/reddit && sudo bundle install
