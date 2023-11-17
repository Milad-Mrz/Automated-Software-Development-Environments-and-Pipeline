#!/bin/bash

vagrant global-status --prune | awk '/virtualbox.*running/ {print $1}' | xargs -L1 vagrant halt

# Restart port 8080 8081 8082
echo "Restart ports..."
lsof -i :8080 && lsof -i :8081 && lsof -i :8082
fuser -k 8080/tcp && fuser -k 8081/tcp && fuser -k 8082/tcp

echo "website closed"
echo "terminal will be closed in 10 seconds"
sleep 10
pkill -f "gnome-terminal"
