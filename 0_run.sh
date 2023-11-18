#!/bin/bash
echo "closing all running vagrant virtual machines in 10 seconds...   (ctrl+C to stop)"
sleep 10
vagrant global-status --prune | awk '/virtualbox.*running/ {print $1}' | xargs -L1 vagrant halt

# List of ports to restart
start_port=8080
end_port=8110

echo "Restarting ports:"

# Loop through the range of ports
for ((port=start_port; port<=end_port; port++)); do
    # Check if the port is in use and kill the process
    lsof -i :$port && fuser -k $port/tcp
done

echo "Ports restarted."


#checking for dependencies
echo "checking for dependencies"
# Check Ansible version
current_version=$(ansible --version | awk -F '[[:space:]]+' '/ansible/ {print $2; exit}')

#Initialising CI server			--------------------------------------------
echo "Initialising CI server"
gnome-terminal -- bash -c './scripts/2_ci_server.sh; exec bash'  &

Product_url="http://192.168.56.9/gitlab/users/sign_in"
http_status=""

echo "Waiting for the CI server to start... (~20 min)"

# Use a while loop to repeatedly check if the Product is running
while true; do
	http_status=$(curl -s -o /dev/null -w "%{http_code}" $Product_url)
	if [ "$http_status" == "200" ] ; then
		clear
		echo "CI server is running. HTTP Status: $http_status"
		break
	else
		sleep 30
	fi
done


echo "Initialising all environments... (~10 min)"
# Initialising Developer env.	--------------------------------------------
echo "1-Developer env."
gnome-terminal -- bash -c './scripts/1_dev_env.sh; exec bash'  &

# Initialising staging env.		--------------------------------------------
echo "2-Staging env."
gnome-terminal -- bash -c './scripts/3_stg_env.sh; exec bash'  &

# Initialising Production env.	--------------------------------------------
echo "3-Production env."
gnome-terminal -- bash -c './scripts/4_pro_env.sh; exec bash'  &

clear
echo -e " \n\n System is running... \n\n" 
echo -e "GitLab: http://192.168.56.9/gitlab/users/sign_in"

sleep 30 
exit
