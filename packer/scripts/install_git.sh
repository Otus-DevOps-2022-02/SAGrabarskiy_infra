#!/bin/bash
function wait_for_apt_lock() {
    while [ "" = "" ]; do
        eval "$1" 2>/dev/null
        if [ $? -eq 0 ]; then
            break
        fi
        sleep 1
        echo "Waiting for apt lock..."
    done
}
wait_for_apt_lock "apt-get install -y git"
