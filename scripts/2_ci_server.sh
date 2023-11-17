#!/bin/bash

echo "Starting CI-Server"
cd 2_ci_server

# Run `vagrant up` command
vagrant halt && vagrant up