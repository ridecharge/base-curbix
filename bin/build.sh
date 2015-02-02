#!/bin/sh
./bin/install_roles.sh
packer build -only=ubuntu14lts aws.json
