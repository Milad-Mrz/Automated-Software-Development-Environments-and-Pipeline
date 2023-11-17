#!/bin/bash

# Set root password (script that I created)
sudo gitlab-rails runner /home/vagrant/scripts/gitlab-set-root-password.rb

# Create a second user (script that I created)
sudo gitlab-rails runner /home/vagrant/scripts/gitlab-user-create.rb
