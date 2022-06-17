#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository

GENERATE_TARGET="$1"

if [ -z "$GENERATE_TARGET" ]
then
      GENERATE_TARGET="all"
fi

case "$GENERATE_TARGET" in
  "all" | "infra" | "infrastructure" | "i")
    iascable build -i ./000-ibm-zdev-account-setup.yaml -o ../../../../../automation-ibmcloud-infra-zos-dev
    iascable build -i ./100-ibm-zdev-shared-services.yaml -o ../../../../../automation-ibmcloud-infra-zos-dev
    iascable build -i ./110-ibm-zdev-network-vpc.yaml -o ../../../../../automation-ibmcloud-infra-zos-dev
    iascable build -i ./120-ibm-zdev-development-vpc.yaml -o ../../../../../automation-ibmcloud-infra-zos-dev
    iascable build -i ./130-ibm-zdev-development-vpc-openshift.yaml -o ../../../../../automation-ibmcloud-infra-zos-dev
  ;;
esac

case "$GENERATE_TARGET" in
  "all" | "software" | "s")
    iascable build -i ./160-ibm-zdev-openshift-dev-tools.yaml -o ../../../../../automation-ibmcloud-infra-zos-dev
  ;;
esac

cp -R -L ./files/* ../../../../../automation-ibmcloud-infra-zos-dev

