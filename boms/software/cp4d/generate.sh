#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository

SOLUTION=automation-cp4d
OUTPUT_PATH=../../../../

iascable build -i ./200-openshift-gitops.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./200-openshift-gitops.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./210-aws-portworx-storage.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./210-azure-portworx-storage.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./210-ibm-odf-storage.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./210-ibm-portworx-storage.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./300-cloud-pak-for-data.yaml -o $OUTPUT_PATH$SOLUTION



echo "Copying Files"
cp ./files/* $OUTPUT_PATH$SOLUTION

echo "Generated Output:"
ls -la $OUTPUT_PATH$SOLUTION