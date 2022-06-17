#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository

GENERATE_DESTINATION="$1"

if ! command -v iascable 1> /dev/null 2> /dev/null; then
  echo "iascable cli not found" >&2
  echo "  Install iascable with this command: curl -sL https://raw.githubusercontent.com/cloud-native-toolkit/iascable/main/install.sh | sh" >&2
  exit 1
fi

IASCABLE_MAJOR_VERSION=$(iascable --version | sed -E "s/^([0-9]+)[.][0-9]+[.][0-9]+/\1/g")
IASCABLE_MINOR_VERSION=$(iascable --version | sed -E "s/^[0-9]+[.]([0-9]+)[.][0-9]+/\1/g")

if [[ "${IASCABLE_MAJOR_VERSION}" -le 2 ]] && [[ "${IASCABLE_MINOR_VERSION}" -le 11 ]]; then
  echo "Installed iascable cli is backlevel version"
  echo "  Update iascable with this command: curl -sL https://raw.githubusercontent.com/cloud-native-toolkit/iascable/main/install.sh | sh" >&2
  exit 1
fi

if [[ -z "${GENERATE_DESTINATION}" ]]; then
  GENERATE_DESTINATION="../../../../automation-fscloud"
fi

mkdir -p "${GENERATE_DESTINATION}"

iascable build \
  -i ./000-ibm-fs-account-setup.yaml \
  -i ./100-ibm-fs-shared-services.yaml \
  -i ./110-ibm-fs-edge-vpc.yaml \
  -i ./120-ibm-fs-management-vpc.yaml \
  -i ./130-ibm-fs-management-vpc-openshift.yaml \
  -i ./140-ibm-fs-workload-vpc.yaml \
  -i ./150-ibm-fs-workload-vpc-openshift.yaml \
  -i ./160-ibm-fs-openshift-dev-tools.yaml \
  -i ./165-ibm-fs-openshift-workload.yaml \
  -o "${GENERATE_DESTINATION}"

cp -R -L ./files/* "${GENERATE_DESTINATION}"

