#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

TARGET_DIR="${1:-../../../../automation-maximo-app-suite}"

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

iascable build \
  -i ./200-openshift-gitops.yaml \
  -i ./210-aws-portworx-storage.yaml \
  -i ./210-azure-portworx-storage.yaml \
  -i ./210-ibm-odf-storage.yaml \
  -i ./210-ibm-portworx-storage.yaml \
  -i ./400-mas-core-multicloud.yaml \
  -o "${TARGET_DIR}"
#iascable build -i ./405-mas-manage.yaml -o ../../../../automation-maximo-app-suite

echo "Copying Files"
cp -L ./files/* "${TARGET_DIR}"
