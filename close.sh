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
echo "system closed"
