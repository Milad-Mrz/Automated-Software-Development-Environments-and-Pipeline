#!/bin/bash

# Step 1: Use a while loop to repeatedly to check the flag_staging
FLAG_FILE="/home/vagrant/shared/flag_staging"
FLAG_PRD="/home/vagrant/shared/flag_production"

Product_url="http://192.168.56.96:8106/"
http_status=""



echo "checking staging flag..."

while true; do
    # Read the content of the flag file
    flag_content=$(cat $FLAG_FILE)

    # test 1: Check if the content is equal to "1"
    if [ "$flag_content" == "1" ]; then
        # Perform test here
        #echo "perform the smoke tests"
        
		pkill -f stage.jar

		# Step 4: Copy the new JAR file from the shared folder
		sudo cp /home/vagrant/shared/e4l-server.jar /home/vagrant/stage.jar
        sudo cp -r /home/vagrant/shared/frontend /home/vagrant/frontend

		# Step 5: Run the Java application
		chmod +x /home/vagrant/stage.jar
        gnome-terminal -- bash -c 'java -jar /home/vagrant/stage.jar.jar'  &
		 
        sed -i 's/PUBLIC_PATH//g' /home/vagrant/frontend/index.html
        sed -i 's/_index2\.default\.defaults\.baseURL = "http:\/\/192\.168\..*:\([0-9]\+\)\/e4lapi";/_index2.default.defaults.baseURL = "http:\/\/192.168.56.96:8080\/e4lapi";/' /home/vagrant/frontend/js/main.js

        # Echo "0" back into the flag file
        echo "0" > $FLAG_FILE
        echo "Staging flag set to 0."

        # Check if the Product is running
        # Use a while loop to repeatedly check if the Product is running
        echo "Waiting for the product to run on staging environment..."
        sleep 120
        cd /home/vagrant/frontend/ && python3 -m http.server 8106

        while true; do
            http_status=$(curl -s -o /dev/null -w "%{http_code}" $Product_url)
            if [ "$http_status" == "200" ] ; then
                echo "staging is running. LINK: $Product_url"
                touch "/home/vagrant/shared/flag_production"
                echo "1" > "/home/vagrant/shared/flag_production"
                echo "Production flag set to 1."
                break
            else                
                sleep 5
            fi
        done


		


    fi

    # Sleep for 10 seconds
    sleep 10
done










