#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository



if [ -z "$SOLUTION" ]
then
  SOLUTION=automation-integration-platform-generated
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
iascable build -i ./215-integration-platform-navigator.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./220-integration-apiconnect.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./230-integration-mq.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./240-integration-ace.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./250-integration-eventstreams.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./260-integration-mq-uniform-cluster.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./280-integration-platform-multicloud.yaml -o $OUTPUT_PATH$SOLUTION


echo "Copying Files"
cp -Lr ./files/* $OUTPUT_PATH$SOLUTION

echo "Generated Output:"
ls -la $OUTPUT_PATH$SOLUTION