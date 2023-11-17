## DevOps Final Project

## Prerequisites

### Hardware

1. Laptop with at least 8 Gb memory (recommended 16 Gb, ideally 32 Gb)

### Dependencies
- OS Ubuntu 18.04 
- VirtualBox (version 6.0 or higher)
- Vagrant (version 2.2.5 or higher)
- Ansible (version 2.9.1)

### Group Members
- Louis Weber - 019087433A
- Milad Mirzaei - 0210941626
- Md Asad Uzzaman Noor - 022147662E

### How to Run the Project
```bash
./run.sh
```
The run.sh script is a Bash script for setting up and initializing a development environment, continuous integration (CI) server, staging environment, and a product environment.

1. Turn Off Vagrant Machines:The script starts by turning off all Vagrant machines using the vagrant global-status command, targeting running VirtualBox instances and halting them.

2. Check Ansible Version:It checks the version of Ansible installed on the system and compares it with a desired version (2.9.1). If the installed version matches the desired one, it prints a message; otherwise, it indicates that the required Ansible version is not installed.

3. Restart Ports:The script defines an array of ports (8080, 8081, 8082) and attempts to restart them. It checks if each port is in use, and if so, it kills the process using that port.

4. Initialize Developer and CI Server:The script launches two separate instances of gnome-terminal to run scripts (1_dev_env.sh and 2_ci_server.sh) in the background.

5. Check CI Server Status:It checks the status of the CI server by making HTTP requests to a specified URL (http://192.168.56.9/gitlab/users/sign_in). It waits until the server returns an HTTP status code of 200 (OK), indicating that the CI server is running.

6. Initialize Staging Environment:Another gnome-terminal instance is launched to run a script (3_stg_env.sh) that presumably sets up the staging environment.

7. Check Staging Environment Status:Similar to the CI server check, it monitors the status of the staging environment until it receives an HTTP status code of 200.

8. Open Firefox:It opens the Firefox browser to the URL http://0.0.0.0:8081/, suggesting that the staging environment or product is accessible through this URL.

9. Initialize Product Environment:Another gnome-terminal instance is launched to run a script (4_pro_env.sh) that presumably sets up the product environment.

10. Check Product Environment Status:Similar to the previous checks, it monitors the status of the product environment until it receives an HTTP status code of 200.

11. Print Success Message:Finally, it prints a message indicating that the product is running.


