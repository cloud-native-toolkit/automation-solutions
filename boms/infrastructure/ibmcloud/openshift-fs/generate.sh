#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository

GENERATE_TARGET="$1"

if [ -z "$GENERATE_TARGET" ]
then
      GENERATE_TARGET="all"
fi

mkdir -p ../../../../automation-fscloud

case "$GENERATE_TARGET" in
  "all" | "infra" | "infrastructure" | "i")
    iascable build -i ./000-ibm-fs-account-setup.yaml -o ../../../../../automation-fscloud
    iascable build -i ./100-ibm-fs-shared-services.yaml -o ../../../../../automation-fscloud
    iascable build -i ./110-ibm-fs-edge-vpc.yaml -o ../../../../../automation-fscloud
    iascable build -i ./120-ibm-fs-management-vpc.yaml -o ../../../../../automation-fscloud
    iascable build -i ./130-ibm-fs-management-vpc-openshift.yaml -o ../../../../../automation-fscloud
    iascable build -i ./140-ibm-fs-workload-vpc.yaml -o ../../../../../automation-fscloud
    iascable build -i ./150-ibm-fs-workload-vpc-openshift.yaml -o ../../../../../automation-fscloud
  ;;
esac


case "$GENERATE_TARGET" in
  "all" | "software" | "s")
    iascable build -i ./160-ibm-fs-openshift-dev-tools.yaml -o ../../../../../automation-fscloud
    iascable build -i ./165-ibm-fs-openshift-workload.yaml -o ../../../../../automation-fscloud
    iascable build -i ./170-ibm-fs-openshift-gitops.yaml -o ../../../../../automation-fscloud
  ;;
esac

cp -R ./files/* ../../../../../automation-fscloud
