#!/bin/bash
echo "turning off all vagrant machines..."
vagrant global-status --prune | awk '/virtualbox.*running/ {print $1}' | xargs -L1 vagrant halt

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





# List of ports to restart
ports=(8080 8081 8082)

echo "Restarting ports: ${ports[@]}"

# Loop through the list of ports
for port in "${ports[@]}"; do
    echo "Restarting port $port..."
    
    # Check if the port is in use and kill the process
    lsof -i :$port && fuser -k $port/tcp
done

echo "Ports restarted."




#---------------------------------------------------------------------------------------------------
echo "Initialising Developer and CI server..."

# Run in background
gnome-terminal -- bash -c './scripts/1_dev_env.sh; exec bash'  &
gnome-terminal -- bash -c './scripts/2_ci_server.sh; exec bash'  &

backend_url="http://192.168.56.9/gitlab/users/sign_in"
http_status=""
WAIT_SECONDS=5

# Use a while loop to repeatedly check if the backend is running
while true; do
	http_status=$(curl -s -o /dev/null -w "%{http_code}" $backend_url)
	if [ "$http_status" == "200" ] ; then
		echo "CI server is running. HTTP Status: $http_status"
		break
	else
		clear
		echo "Waiting for the CI server to start..."
		sleep $WAIT_SECONDS
	fi
done

#---------------------------------------------------------------------------------------------------
echo "Initialising staging..."
gnome-terminal -- bash -c './scripts/3_stg_env.sh; exec bash'  &

# Check if the backend is running
backend_url="http://localhost:8081/e4l"
http_status=""
WAIT_SECONDS=5

# Use a while loop to repeatedly check if the backend is running
while true; do
	http_status=$(curl -s -o /dev/null -w "%{http_code}" $backend_url)
	if [ "$http_status" == "200" ] ; then
		echo "Product is running. HTTP Status: $http_status"
		break
	else
		clear
		echo "Waiting for the product to run on staging environment..."
		sleep $WAIT_SECONDS
	fi
done


clear
echo "Product is running."
echo "Opening firefox ..."
firefox "http://0.0.0.0:8081/"


#---------------------------------------------------------------------------------------------------
echo "Initialising the product..."
gnome-terminal -- bash -c './scripts/4_pro_env.sh; exec bash'  &

# Check if the backend is running
backend_url="http://localhost:8081/e4l"
http_status=""
WAIT_SECONDS=5

# Use a while loop to repeatedly check if the backend is running
while true; do
	http_status=$(curl -s -o /dev/null -w "%{http_code}" $backend_url)
	if [ "$http_status" == "200" ] ; then
		echo "product is running. HTTP Status: $http_status"
		break
	else
		clear
		echo "Waiting for the backend to start..."
		sleep $WAIT_SECONDS
	fi
done

