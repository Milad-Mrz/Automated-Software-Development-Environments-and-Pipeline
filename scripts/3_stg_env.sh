#!/bin/bash

echo "Starting Staging Env."
cd 3_staging_env

# Run `vagrant up` command
vagrant destroy && vagrant up