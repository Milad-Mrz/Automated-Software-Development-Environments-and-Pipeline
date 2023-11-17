#!/bin/bash

echo "Starting Development Env."
cd 1_development_env

# Run `vagrant up` command
vagrant halt && vagrant up
#vagrant up && vagrant ssh -c 'cd lu.uni.e4l.platform.api.dev && ./gradlew bootRun'