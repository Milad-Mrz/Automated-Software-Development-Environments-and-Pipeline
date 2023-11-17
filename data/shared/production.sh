#!/bin/bash

# Step 1: Use a while loop to repeatedly to check the flag_production
FLAG_FILE="/home/vagrant/shared/flag_production"
Product_url="http://192.168.56.97:8107"
http_status=""

clear

sudo touch "/home/vagrant/shared/flag_production"
echo -e "Production Env:\n\n"
echo "checking production flag..."

while true; do
    # Read the content of the flag file
    flag_content=$(cat $FLAG_FILE)

    # Check if the content is equal to "1"
    if [ "$flag_content" == "1" ]; then
        # update the jar file and restart the product
        echo "restart ports, back-end and front-end"        
        # back-end
        # Step 2: Stop the running Java application
        sudo pkill -f product_backend.jar
        # kill server
        sudo pkill -f "python3 -m http.server 8107"
        # reset ports
        ports=(8080 8081 8106 8107)
        # Loop through the list of ports
        for port in "${ports[@]}"; do
            sudo lsof -i :$port && fuser -k $port/tcp
        done

        # Step 3: Copy the new JAR file from the shared folder
        sudo rm /home/vagrant/product_backend.jar
        sudo cp /home/vagrant/shared/e4l-server.jar /home/vagrant/product_backend.jar
        sudo rm /home/vagrant/shared/e4l-server.jar
        # Step 4: Run the Java application
        sudo chmod +x /home/vagrant/product_backend.jar
        sudo nohup bash -c 'java -jar /home/vagrant/product_backend.jar'  &

        # front-end
        sudo rm -r /home/vagrant/frontend
        sudo cp -r /home/vagrant/shared/frontend /home/vagrant/frontend
		# Step 5: Run the Java application
        sudo sed -i 's/PUBLIC_PATH//g' /home/vagrant/frontend/index.html
        sudo sed -i 's/_index2\.default\.defaults\.baseURL = "http:\/\/192\.168\..*:\([0-9]\+\)\/e4lapi";/_index2.default.defaults.baseURL = "http:\/\/192.168.56.97:8080\/e4lapi";/' /home/vagrant/frontend/js/main.js

        # Use a while loop to repeatedly check if the Product is running
        echo "Waiting for the back-end to run... (~2 minutes)"
        sleep 60 
        sudo nohup bash -c 'cd /home/vagrant/frontend/ && python3 -m http.server 8107'  & 
        clear
        echo "update the jar file and restart the product"

        while true; do
            http_status=$(curl -s -o /dev/null -w "%{http_code}" $Product_url)
            if [ "$http_status" == "200" ] ; then
                echo -e " \n\n"
                echo -e " \n\n"
                echo "product is running. LINK: $Product_url"
                echo -e " \n\n"
                echo -e " \n\n"
                # Echo "0" back into the flag file
                sudo echo "0" > "/home/vagrant/shared/flag_production"
                echo "Flag set to 0."


                break
            else        
                sleep 5
            fi
        done


    fi

    # Sleep for 10 seconds
    sleep 10
done







