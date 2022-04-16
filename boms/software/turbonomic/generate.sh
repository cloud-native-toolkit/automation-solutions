#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository

iascable build -i ./200-openshift-gitops.yaml -o ../../../../automation-turbonomic
iascable build -i ./202-turbonomic-ibmcloud-storage-class.yaml -o ../../../../automation-turbonomic
iascable build -i ./250-turbonomic-multicloud.yaml -o ../../../../automation-turbonomic
cp -R ./files/* ../../../../automation-turbonomic
