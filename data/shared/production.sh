#!/bin/bash

# Step 1: Use a while loop to repeatedly to check the flag_production
FLAG_FILE="/home/vagrant/shared/flag_production"
Product_url="http://192.168.56.97:8107"
http_status=""



touch "/home/vagrant/shared/flag_production"
echo "checking production flag..."

while true; do
    # Read the content of the flag file
    flag_content=$(cat $FLAG_FILE)

    # Check if the content is equal to "1"
    if [ "$flag_content" == "1" ]; then
        # update the jar file and restart the product
        echo "update the jar file and restart the product"
        
        # back-end
        # Step 2: Stop the running Java application
        pkill -f product_backend.jar
        # Step 3: Copy the new JAR file from the shared folder
        sudo rm /home/vagrant/product_backend.jar
        sudo cp /home/vagrant/shared/e4l-server.jar /home/vagrant/product_backend.jar
        sudo rm /home/vagrant/shared/e4l-server.jar
        # Step 4: Run the Java application
        chmod +x /home/vagrant/product_backend.jar
        gnome-terminal -- bash -c 'java -jar /home/vagrant/product_backend.jar'  &

        # front-end
        sudo rm -r /home/vagrant/frontend
        sudo cp -r /home/vagrant/shared/frontend /home/vagrant/frontend
		# Step 5: Run the Java application
        sed -i 's/PUBLIC_PATH//g' /home/vagrant/frontend/index.html
        sed -i 's/_index2\.default\.defaults\.baseURL = "http:\/\/192\.168\..*:\([0-9]\+\)\/e4lapi";/_index2.default.defaults.baseURL = "http:\/\/192.168.56.97:8080\/e4lapi";/' /home/vagrant/frontend/js/main.js

        # Use a while loop to repeatedly check if the Product is running
        echo "Waiting for the Product to run..."
        sleep 120 
        cd /home/vagrant/frontend/ && python3 -m http.server 8107  

        while true; do
            http_status=$(curl -s -o /dev/null -w "%{http_code}" $Product_url)
            if [ "$http_status" == "200" ] ; then
                echo "product is running. LINK: $Product_url"
                # Echo "0" back into the flag file
                echo "0" > "/home/vagrant/shared/flag_production"
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







