#!/bin/bash
sudo mv /tmp/puma.service /etc/systemd/system/puma.service
sudo chmod 644 /etc/systemd/system/puma.service
sudo systemctl daemon-reload
sudo systemctl start puma.service
sudo systemctl enable puma.service
