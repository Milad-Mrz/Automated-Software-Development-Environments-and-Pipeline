#!/bin/bash

# Step 1: Use a while loop to repeatedly to check the flag_staging
FLAG_FILE="/home/vagrant/shared/flag_staging"
FLAG_PRD="/home/vagrant/shared/flag_production"

Product_url="http://192.168.56.96:8106/"
http_status=""

clear
#sudo touch "/home/vagrant/shared/flag_staging"
echo -e "Staging Env:\n\n"
echo "checking staging flag..."

while true; do
    # Read the content of the flag file
    if [ -e "$FLAG_FILE" ]; then
    # File exists, read its content
        flag_content=$(cat "$FLAG_FILE")
    else
    # File doesn't exist, set flag_content to zero or any other default value
        flag_content=0
    fi

    # test 1: Check if the content is equal to "1"
    if [ "$flag_content" == "1" ]; then
        # Perform test here
        echo "restart ports, back-end and front-end"
        
        # kill jar
		sudo pkill -f stage.jar
        # kill server and port
        sudo pkill -f "python3 -m http.server 8106"
        # reset ports
        ports=(8080 8081 8106 8107)
        # Loop through the list of ports
        for port in "${ports[@]}"; do
            sudo lsof -i :$port && fuser -k $port/tcp
        done

		# Step 4: Copy the new JAR file from the shared folder
		sudo cp /home/vagrant/shared/e4l-server.jar /home/vagrant/stage.jar
        sudo cp -r /home/vagrant/shared/frontend /home/vagrant/frontend

		# Step 5: Run the Java application
		sudo chmod +x /home/vagrant/stage.jar
        sudo nohup bash -c 'java -jar /home/vagrant/stage.jar.jar'  &
		 
        sudo sed -i 's/PUBLIC_PATH//g' /home/vagrant/frontend/index.html
        sudo sed -i 's/_index2\.default\.defaults\.baseURL = "http:\/\/192\.168\..*:\([0-9]\+\)\/e4lapi";/_index2.default.defaults.baseURL = "http:\/\/192.168.56.96:8080\/e4lapi";/' /home/vagrant/frontend/js/main.js

        # Echo "0" back into the flag file
        #sudo echo "0" > $FLAG_FILE
        echo "staging flag set to 0."

        # Check if the Product is running
        # Use a while loop to repeatedly check if the Product is running
        echo "perform the smoke tests for back-end... (~2 minutes)"
        sleep 60
        sudo nohup bash -c 'cd /home/vagrant/frontend/ && python3 -m http.server 8106'  &
        clear
        echo "perform the smoke tests for front-end (~2 minutes)"

        while true; do
            http_status=$(curl -s -o /dev/null -w "%{http_code}" $Product_url)
            if [ "$http_status" == "200" ] ; then
                echo -e " \n\n"
                echo "Staging is compelete (http status: $http_status)"
                echo -e " \n\n"
                # sudo touch "/home/vagrant/shared/flag_production"
                sudo echo "1" > "/home/vagrant/shared/flag_production"
                echo "Production flag set to 1."
                sudo rm "/home/vagrant/shared/flag_staging"
                break
            else                
                sleep 5
            fi
        done


		


    fi

    # Sleep for 10 seconds
    sleep 10
done










