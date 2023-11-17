#!/bin/bash

clear
echo "Starting CI-Server"
cd 2_ci_server

# Run `vagrant up` command
vagrant halt && vagrant up

clear && echo -e "CI-Server:\n\n"
vagrant ssh
