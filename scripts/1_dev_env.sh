#!/bin/bash

echo "Starting Development Env."
cd 1_development_env

# Run `vagrant up` command
vagrant halt -f && vagrant up 

vagrant ssh -c ' clear && echo -e "CI-Server:\n\n" '

