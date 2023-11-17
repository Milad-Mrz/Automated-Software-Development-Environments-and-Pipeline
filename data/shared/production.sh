#!/bin/bash

# Step 1: Use a while loop to repeatedly to check the flag_production
FLAG_FILE="/home/vagrant/shared/flag_production"

while true; do
    # Read the content of the flag file
    flag_content=$(cat $FLAG_FILE)

    # Check if the content is equal to "1"
    if [ "$flag_content" == "1" ]; then
        # update the jar file and restart the product
        echo "update the jar file and restart the product"
        
        # Step 2: Stop the running Java application
        pkill -f e4l-server.jar

        # Step 3: Copy the new JAR file from the shared folder
        sudo cp /home/vagrant/shared/e4l-server.jar /home/vagrant/released_version/e4l-server.jar
        sudo rm /home/vagrant/shared/e4l-server.jar

        # Step 4: Run the Java application
        chmod +x /home/vagrant/released_version/e4l-server.jar
        java -jar /home/vagrant/released_version/e4l-server.jar

        # Echo "0" back into the flag file
        echo "0" > $FLAG_FILE
        echo "Flag set to 0."
    fi

    # Sleep for 10 seconds
    sleep 10
done







