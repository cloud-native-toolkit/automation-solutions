#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository

iascable build -i ./200-openshift-gitops.yaml -o ../../../../automation-maximo-app-suite
iascable build -i ./210-aws-portworx-storage.yaml -o ../../../../automation-maximo-app-suite
iascable build -i ./210-azure-portworx-storage.yaml -o ../../../../automation-maximo-app-suite
iascable build -i ./210-ibm-odf-storage.yaml -o ../../../../automation-maximo-app-suite
iascable build -i ./210-ibm-portworx-storage.yaml -o ../../../../automation-maximo-app-suite
iascable build -i ./400-mas-core-multicloud.yaml -o ../../../../automation-maximo-app-suite
#iascable build -i ./405-mas-manage.yaml -o ../../../../automation-maximo-app-suite

echo "Copying Files"
cp ./files/* ../../../../automation-maximo-app-suite
