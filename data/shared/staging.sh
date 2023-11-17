#!/bin/bash

# Step 1: Use a while loop to repeatedly to check the flag_staging
FLAG_FILE="/home/vagrant/shared/flag_staging"
FLAG_PRD="/home/vagrant/shared/flag_production"

while true; do
    # Read the content of the flag file
    flag_content=$(cat $FLAG_FILE)

    # Check if the content is equal to "1"
    if [ "$flag_content" == "1" ]; then
        # Perform test here
        echo "perform the smoke tests"
        
		pkill -f e4l-server.jar

		# Step 4: Copy the new JAR file from the shared folder
		sudo cp /home/vagrant/shared/e4l-server.jar /home/vagrant/latest_version/e4l-server.jar

		# Step 5: Run the Java application
		chmod +x /home/vagrant/released_version/e4l-server.jar
		java -jar /home/vagrant/latest_version/e4l-server.jar

        # Echo "0" back into the flag file
        echo "0" > $FLAG_FILE
		echo "1" > $FLAG_PRD

        echo "Staging flag set to 0."
		echo "Production flag set to 1."


    fi

    # Sleep for 10 seconds
    sleep 10
done










