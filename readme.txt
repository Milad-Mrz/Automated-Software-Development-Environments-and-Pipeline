
____________________________________________________________________


Group Members
- Louis Weber - ID: 019087433A
- Milad Mirzaei - ID: 0210941626
- Md Asad Uzzaman Noor - ID: 022147662E

____________________________________________________________________

# DevOps Final Project Report   (https://github.com/Milad-Mrz/devops_final_project/tree/main)

Prerequisites

Hardware Requirements
Ensure your laptop has at least 16 GB of memory (32 GB recommended).

Software Dependencies
- Operating System: Ubuntu 18.04 
- Virtualization Software: VirtualBox (version 6.0 or higher)
- Provisioning Tool: Vagrant (version 2.2.5 or higher)
- Configuration Management Tool: Ansible (version 2.9.1)


____________________________________________________________________

## Running the Project

To execute the project, use the following Bash command:

__bash______________________________________________________________

./run.sh
____________________________________________________________________

The `run.sh` script automates the setup with the following steps:

1. Turning Off Virtual Machines: Ensures any running Vagrant virtual machines are turned off.
2. Restarting Ports: Restarts ports 8080 to 8088, resolving potential conflicts with other programs.
3. Initializing CI Server: Launches the CI server script (`2_ci_server.sh`) in the background. The CI server monitors the staging environment's status, waiting for an HTTP status code of 200. It then makes HTTP requests to specific URLs (`http://192.168.56.9/gitlab`, development environment, etc.).
4. Managing Environments: After each commit, the development environment (`1_dev_env.sh`) is relaunched, and the product is redeployed on the staging environment (`3_stg_env.sh`). The CI server monitors a flag to confirm completion of each deployment.
5. Activating Production Environment: Once the flag is positive (equal to 1), the production and staging environments (`4_pro_env.sh`) are activated. This involves copying the compiled JAR file from the CI server through a shared file, running tests, and releasing the production environment after passing HTTP status tests.

To stop the project and clean up ports, use the following command:

```bash
./close.sh
```

The `close.sh` script turns off running Vagrant virtual machines and restarts the ports (8080 to 8088) in case they were not closed properly.

____________________________________________________________
```
