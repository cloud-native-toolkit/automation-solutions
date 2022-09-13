#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository

if [ -z "$SOLUTION" ]
then
  SOLUTION=automation-datafabric
fi

if [ -z "$OUTPUT_PATH" ]
then
  OUTPUT_PATH=../../../../
fi

mkdir -p $OUTPUT_PATH$SOLUTION

iascable build -i ./200-openshift-gitops.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./210-aws-portworx-storage.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./210-azure-portworx-storage.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./210-ibm-odf-storage.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./210-ibm-portworx-storage.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./300-cloud-pak-for-data-entitlement.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./305-cloud-pak-for-data-foundation.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./600-datafabric-services-odf.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./600-datafabric-services-portworx.yaml -o $OUTPUT_PATH$SOLUTION


#               -i ./600-datafabric-services.yaml \
#               -i ./610-datafabric-demo.yaml -o $OUTPUT_PATH$SOLUTION



echo "Copying Files"
cp -R -L ./files/* $OUTPUT_PATH$SOLUTION

echo "Generated Output:"
ls -la $OUTPUT_PATH$SOLUTION