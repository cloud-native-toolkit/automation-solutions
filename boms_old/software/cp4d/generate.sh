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

iascable build -i ./105-existing-openshift.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./200-openshift-gitops.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./210-ibm-odf-storage.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./300-cloud-pak-for-data-foundation.yaml -o $OUTPUT_PATH$SOLUTION


echo "Copying Files"
cp -v -R -L ./files/* $OUTPUT_PATH$SOLUTION
cp -LR ./files/.mocks $OUTPUT_PATH$SOLUTION/

echo "Generated Output:"
ls -la $OUTPUT_PATH$SOLUTION