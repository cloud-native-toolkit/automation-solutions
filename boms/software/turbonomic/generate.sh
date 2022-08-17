#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository

iascable build -i ./200-openshift-gitops.yaml -o ../../../../automation-turbonomic
iascable build -i ./250-turbonomic-multicloud.yaml -o ../../../../automation-turbonomic
echo "Copying Files"
cp ./files/* ../../../../automation-turbonomic
echo "Copying Configuration"
cp -R -L ./files/configuration ../../../../automation-turbonomic/configuration
