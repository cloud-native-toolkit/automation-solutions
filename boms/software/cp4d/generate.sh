#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository

if [ -z "$SOLUTION" ]
then
  SOLUTION=automation-data-foundation
fi

if [ -z "$OUTPUT_PATH" ]
then
  OUTPUT_PATH=../../../../
fi

mkdir -p $OUTPUT_PATH$SOLUTION

iascable build -i ./200-openshift-gitops.yaml \
               -i ./210-aws-portworx-storage.yaml \
               -i ./210-azure-portworx-storage.yaml \
               -i ./210-ibm-odf-storage.yaml -\
               -i ./210-ibm-portworx-storage.yaml \
               -i ./300-cloud-pak-for-data-entitlement.yaml \
               -i ./305-cloud-pak-for-data-foundation.yaml -o $OUTPUT_PATH$SOLUTION

#                \
#                              -i ./310-cloud-pak-for-data-db2uoperator.yaml \
#                              -i ./315-cloud-pak-for-data-db2wh.yaml \
#                              -i ./320-cloud-pak-for-data-db2oltp.yaml


echo "Copying Files"
cp -v -R -L ./files/* $OUTPUT_PATH$SOLUTION

echo "Generated Output:"
ls -la $OUTPUT_PATH$SOLUTION