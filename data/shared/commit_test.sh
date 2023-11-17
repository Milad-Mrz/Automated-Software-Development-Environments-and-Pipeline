#!/bin/bash
sleep 120
Product_url="http://192.168.56.9/gitlab/users/sign_in"
http_status=""
echo "gitlab initialize: Waiting for the CI server"
# Use a while loop to repeatedly check if the Product is running
while true; do
	http_status=$(curl -s -o /dev/null -w "%{http_code}" $Product_url)
	if [ "$http_status" == "200" ] ; then
        touch /home/vagrant/e4l/test.txt
		sleep 60
        cd /home/vagrant/e4l && sudo git add . && sudo git commit -m "gitlab initialize" && sudo git push origin master
		break
	else		
		sleep 30


	fi
done


