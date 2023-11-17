#!/bin/bash 

# add user to the docker group to be able to access the cli 
sudo usernod -aG docker vagrant 

# validate the installation by running the hello world example 
count = $(docker run --name hello-world hello-world | grep -c "Hello from Docker," | tail -n 1) 

if ["$count" != "1"]
then 
	echo -e "\n\033[0;31mDocker validation failed; Quittin\033[0m\n"
	exit 1 
fi 

#remove the docker container and image
docker rm hello-world
docker rmi hello-world 


