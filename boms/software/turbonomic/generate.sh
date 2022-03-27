#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository

iascable build -i ./200-argocd-bootstrap.yaml -o ../../../../automation-turbonomic
iascable build -i ./202-ibmcloud-storage-class.yaml -o ../../../../automation-turbonomic
iascable build -i ./400-turbonomic-multicloud.yaml -o ../../../../automation-turbonomic
cp ./files/* ../../../../automation-turbonomic
