#!/bin/bash
echo "closing all running vagrant virtual machines in 10 seconds...   (ctrl+C to stop)"
sleep 10
vagrant global-status --prune | awk '/virtualbox.*running/ {print $1}' | xargs -L1 vagrant halt

# List of ports to restart
ports=(8080 8081 8082 8083 8084 8085 8086 8087 8088)

echo "Restarting ports: ${ports[@]}"

# Loop through the list of ports
for port in "${ports[@]}"; do
    echo "Restarting port $port..."
    
    # Check if the port is in use and kill the process
    lsof -i :$port && fuser -k $port/tcp
done

echo "Ports restarted."


#checking for dependencies
echo "checking for dependencies"
# Check Ansible version
current_version=$(ansible --version | awk -F '[[:space:]]+' '/ansible/ {print $2; exit}')

# Desired Ansible version
desired_version="2.9.1"

if [ "$current_version" == "$desired_version" ]; then
    echo "Ansible is installed with version $desired_version"
else
	
    echo "Ansible version $desired_version is not installed."

fi

#Initialising CI server			--------------------------------------------
echo "Initialising CI server"
gnome-terminal -- bash -c './scripts/2_ci_server.sh; exec bash'  &

Product_url="http://192.168.56.9/gitlab/users/sign_in"
http_status=""

# Use a while loop to repeatedly check if the Product is running
while true; do
	http_status=$(curl -s -o /dev/null -w "%{http_code}" $Product_url)
	if [ "$http_status" == "200" ] ; then
		echo "CI server is running. HTTP Status: $http_status"
		break
	else
		clear
		echo "Waiting for the CI server to start..."
		sleep 5
	fi
done

# Initialising Developer env.	--------------------------------------------
echo "Initialising Developer env."
gnome-terminal -- bash -c './scripts/1_dev_env.sh; exec bash'  &

# Initialising staging env.		--------------------------------------------
echo "Initialising staging env."
gnome-terminal -- bash -c './scripts/3_stg_env.sh; exec bash'  &

# Initialising Production env.	--------------------------------------------
echo "Initialising Production env."
gnome-terminal -- bash -c './scripts/4_pro_env.sh; exec bash'  &

echo "system is idle"