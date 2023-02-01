#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository

RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
YELLOW='\033[33;5m'

Usage()
{
   
   echo
   echo "Usage: generate.sh"
   echo "  options:"
   echo -e "  -v     CP4I Version valid values ${RED}(cp4i-2021-4-1, cp4i-2022-2-1)${NC}"
   echo "  -n     (optional) prefix can help you add more meta information to the asset. E.g dev, test, demo etc."
   echo "  -h     Print this help"
   echo
   echo "Generate the Integration Automation Asset for the specified CP4I version."
}

Validate_Input_Param()
{

  if [ -z "$CP4I_VERSION" ] ; then
    echo -e "${RED}CP4I Version Can not be empty.${NC}"
    Usage
    exit 1
  fi


  # If CP4I version is provided then it has be a valid one
  if [[ ! ${CP4I_VERSION} =~  cp4i-2021-4-1|cp4i-2022-2-1 ]]; then
    echo -e  "${RED} Invalid CP4I Version.${NC} Valid Choice are (cp4i-2021-4-1 or cp4i-2022-2-1) !!!!!! "
    Usage
    exit 1
  fi


}



# Get the options
while getopts ":v:n:h" option; do
   case $option in
      h) # display Help
         Usage
         exit 1;;
      v)
         CP4I_VERSION=${OPTARG};;
      n) # Enter a name
         PREFIX_NAME=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         Usage
         exit 1;;
   esac
done

#Validate the Input Parameters
Validate_Input_Param



if [ -z "$SOLUTION" ]
then
  SOLUTION=automation-integration-${CP4I_VERSION}-${PREFIX_NAME}
fi

if [ -z "$OUTPUT_PATH" ]
then
  OUTPUT_PATH=../../../../
fi

rm -rf $OUTPUT_PATH$SOLUTION
mkdir -p $OUTPUT_PATH$SOLUTION

iascable build -i ./${CP4I_VERSION}/105-existing-openshift.yaml -o $OUTPUT_PATH$SOLUTION

iascable build -i ./${CP4I_VERSION}/200-openshift-gitops.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./${CP4I_VERSION}/210-aws-portworx-storage.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./${CP4I_VERSION}/210-azure-portworx-storage.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./${CP4I_VERSION}/210-ibm-odf-storage.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./${CP4I_VERSION}/210-ibm-portworx-storage.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./${CP4I_VERSION}/215-integration-platform-navigator.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./${CP4I_VERSION}/220-integration-apiconnect.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./${CP4I_VERSION}/230-integration-mq.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./${CP4I_VERSION}/240-integration-ace.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./${CP4I_VERSION}/250-integration-eventstreams.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./${CP4I_VERSION}/260-integration-mq-uniform-cluster.yaml -o $OUTPUT_PATH$SOLUTION
iascable build -i ./${CP4I_VERSION}/280-integration-platform-multicloud.yaml -o $OUTPUT_PATH$SOLUTION


echo "Copying Files"
cp -LR ./files/* $OUTPUT_PATH$SOLUTION
cp -LR ./files/.mocks $OUTPUT_PATH$SOLUTION/.mocks

echo "Generated Output:"
ls -la $OUTPUT_PATH$SOLUTION