#!/bin/bash
cd ..
packer build -var-file=variables.json ubuntu16.json
packer build -var-file=variables.json immutable.json
./create-yc-vm.sh
