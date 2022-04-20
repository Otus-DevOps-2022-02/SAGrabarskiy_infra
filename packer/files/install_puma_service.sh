#!/bin/bash
mv /tmp/puma.service /etc/systemd/system/puma.service
sudo chmod 644 /etc/systemd/system/puma.service
systemctl daemon-reload
systemctl enable puma.service
