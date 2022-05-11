#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository

GENERATE_TARGET="$1"
GENERATE_DESTINATION="$2"

if [[ -z "$GENERATE_TARGET" ]]
then
      GENERATE_TARGET="all"
fi

if [[ -z "${GENERATE_DESTINATION}" ]]; then
  GENERATE_DESTINATION="../../../../automation-fscloud"
fi

mkdir -p "${GENERATE_DESTINATION}"

case "$GENERATE_TARGET" in
  "all" | "infra" | "infrastructure" | "i")
    iascable build -i ./000-ibm-fs-account-setup.yaml -o "${GENERATE_DESTINATION}"
    iascable build -i ./100-ibm-fs-shared-services.yaml -o "${GENERATE_DESTINATION}"
    iascable build -i ./110-ibm-fs-edge-vpc.yaml -o "${GENERATE_DESTINATION}"
    iascable build -i ./120-ibm-fs-management-vpc.yaml -o "${GENERATE_DESTINATION}"
    iascable build -i ./130-ibm-fs-management-vpc-openshift.yaml -o "${GENERATE_DESTINATION}"
    iascable build -i ./140-ibm-fs-workload-vpc.yaml -o "${GENERATE_DESTINATION}"
    iascable build -i ./150-ibm-fs-workload-vpc-openshift.yaml -o "${GENERATE_DESTINATION}"
  ;;
esac


case "$GENERATE_TARGET" in
  "all" | "software" | "s")
    iascable build -i ./160-ibm-fs-openshift-dev-tools.yaml -o "${GENERATE_DESTINATION}"
    iascable build -i ./165-ibm-fs-openshift-workload.yaml -o "${GENERATE_DESTINATION}"
    iascable build -i ./170-ibm-fs-openshift-gitops.yaml -o "${GENERATE_DESTINATION}"
  ;;
esac

cp -R ./files/* "${GENERATE_DESTINATION}"

