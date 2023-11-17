#!/bin/bash

#curl --header "PRIVATE-TOKEN: ypCa3Dzb2365nvsixwPP" -X POST "http://192.168.56.9/gitlab/api/v4/projects?name=MavenHelloWorldProject"

# Init local git project
cd /home/vagrant/e4l
git init
git remote add origin http://vagrant:ypCa3Dzb2365nvsixwPP@192.168.56.9/gitlab/vagrant/e4l
#git remote set-url origin git@192.168.56.9:gitlab/vagrant/MavenHelloWorldProject.git

# Configure the git user
git config --global user.name "vagrant"
git config --global user.email "vagrant@vagrant.com"

# Create a .gitignore file to avoid committing logs, dev settings, and binaries 
echo '# Binaries
target/

# Log files
* Log

# Dev settings
.settings' > .gitignore

export GIT_USERNAME=vagrant
export GIT_PASSWORD=12345678

# Push the project
git add .
git commit -m "Initial Commit"
git push origin master

