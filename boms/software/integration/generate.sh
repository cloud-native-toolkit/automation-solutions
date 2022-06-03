#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository



if [ -z "$SOLUTION" ]
then
  SOLUTION=automation-cp4i
fi

if [ -z "$OUTPUT_PATH" ]
then
  OUTPUT_PATH=../../../../
fi

mkdir -p $OUTPUT_PATH$SOLUTION

iascable build -i ./200-openshift-gitops.yaml \
               -i ./210-aws-portworx-storage.yaml \
               -i ./210-azure-portworx-storage.yaml \
               -i ./210-ibm-odf-storage.yaml \
               -i ./210-ibm-portworx-storage.yaml \
               -i ./215-integration-platform-navigator.yaml \
               -i ./220-integration-apiconnect.yaml \
               -i ./230-integration-mq.yaml \
               -i ./240-integration-ace.yaml \
               -i ./250-integration-eventstreams.yaml \
               -i ./260-integration-mq-uniform-cluster.yaml -o $OUTPUT_PATH$SOLUTION



echo "Copying Files"
cp -L ./files/* $OUTPUT_PATH$SOLUTION

echo "Generated Output:"
ls -la $OUTPUT_PATH$SOLUTION