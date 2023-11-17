#!/bin/bash

echo "Starting Production Env."
cd 4_production_env

# Run `vagrant up` command
vagrant destroy -f && vagrant up