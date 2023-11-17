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
echo "system closed"
