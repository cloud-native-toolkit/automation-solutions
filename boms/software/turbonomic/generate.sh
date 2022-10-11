#!/bin/bash

# IBM Ecosystem Lab Team
# Install iascable and run this script to produce an target public source repository

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

TARGET_BASE="${1:-../../../..}"
TARGET_REPO="${2:-automation-turbonomic}"

TARGET_DIR="${TARGET_BASE}/${TARGET_REPO}"

if ! command -v iascable 1> /dev/null 2> /dev/null; then
  echo "iascable cli not found" >&2
  echo "  Install iascable with this command: curl -sL https://raw.githubusercontent.com/cloud-native-toolkit/iascable/main/install.sh | sh" >&2
  exit 1
fi

IASCABLE_MAJOR_VERSION=$(iascable --version | sed -E "s/^([0-9]+)[.][0-9]+[.][0-9]+/\1/g")
IASCABLE_MINOR_VERSION=$(iascable --version | sed -E "s/^[0-9]+[.]([0-9]+)[.][0-9]+/\1/g")

if [[ "${IASCABLE_MAJOR_VERSION}" -le 2 ]] && [[ "${IASCABLE_MINOR_VERSION}" -lt 13 ]]; then
  echo "Installed iascable cli is backlevel version"
  echo "  Update iascable with this command: curl -sL https://raw.githubusercontent.com/cloud-native-toolkit/iascable/main/install.sh | sh" >&2
  exit 1
fi

echo "Generating output into ${TARGET_DIR}"

iascable build \
  -i ./105-existing-openshift.yaml \
  -o "${TARGET_DIR}" \
  --flatten
iascable build \
  -i ./200-openshift-gitops.yaml \
  -o "${TARGET_DIR}" \
  --flatten
iascable build \
  -i ./250-turbonomic-multicloud.yaml \
  -o "${TARGET_DIR}" \
  --flatten

echo "Copying Files"
cp -R -L ./files/* "${TARGET_DIR}"
cp -R -L ./files/.mocks "${TARGET_DIR}"
