#!/bin/sh
./bin/install_roles.sh
packer build aws.json
