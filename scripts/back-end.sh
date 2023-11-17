#!/bin/bash

echo "Starting back-end..."
# Change to the directory where your Vagrantfile is located
cd /home/milad/Desktop/SEE/Lab/devops-lab4/Back-end

# Run `vagrant up` command
vagrant halt
vagrant up && vagrant ssh -c 'cd lu.uni.e4l.platform.api.dev && ./gradlew bootRun'
