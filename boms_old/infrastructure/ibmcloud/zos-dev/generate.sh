#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository

GENERATE_TARGET="$1"
GENERATE_DESTINATION="../../../../../automation-ibmcloud-infra-zos-dev"

if [ -z "$GENERATE_TARGET" ]
then
      GENERATE_TARGET="all"
fi

echo "GENERATE_DESTINATION: $GENERATE_DESTINATION"

case "$GENERATE_TARGET" in
  "all" | "infra" | "infrastructure" | "i")
    iascable build -i ./000-ibm-zdev-account-setup.yaml -o $GENERATE_DESTINATION
    iascable build -i ./100-ibm-zdev-shared-services.yaml -o $GENERATE_DESTINATION
    iascable build -i ./110-ibm-zdev-network-vpc.yaml -o $GENERATE_DESTINATION
    iascable build -i ./120-ibm-zdev-network-vpc-openshift.yaml -o $GENERATE_DESTINATION
  ;;
esac

case "$GENERATE_TARGET" in
  "all" | "software" | "s")
    iascable build -i ./160-ibm-zdev-openshift-dev-tools.yaml -o $GENERATE_DESTINATION -c https://modules.cloudnativetoolkit.dev/index.yaml
    iascable build -i ./165-ibm-openshift-wazi-dev-tools.yaml -o $GENERATE_DESTINATION -c https://modules.cloudnativetoolkit.dev/index.yaml
  ;;
esac

cp -v -R -L ./files/* $GENERATE_DESTINATION


# remove the default, aws, and azure docker images, and uncomment the ibm image
sed -i '' 's/DOCKER_IMAGE\="quay.io\/cloudnativetoolkit\/cli-tools\:.*//' ${GENERATE_DESTINATION}/launch.sh
sed -i '' 's/#AWS.*//' ${GENERATE_DESTINATION}/launch.sh
sed -i '' 's/#AZURE.*//' ${GENERATE_DESTINATION}/launch.sh
sed -i '' 's/#IBM //' ${GENERATE_DESTINATION}/launch.sh
cat ${GENERATE_DESTINATION}/launch.sh | grep quay


