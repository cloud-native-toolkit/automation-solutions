#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

TARGET_BASE="${1:-../../../../..}"
TARGET_REPO="${2:-automation-ibmcloud-infra-openshift}"

TARGET_DIR="${TARGET_BASE}/${TARGET_REPO}"

echo "Generating output into ${TARGET_DIR}"

if ! command -v iascable 1> /dev/null 2> /dev/null; then
  echo "iascable cli not found" >&2
  echo "  Install iascable with this command: curl -sL https://raw.githubusercontent.com/cloud-native-toolkit/iascable/main/install.sh | sh" >&2
  exit 1
fi

IASCABLE_MAJOR_VERSION=$(iascable --version | sed -E "s/^([0-9]+)[.][0-9]+[.][0-9]+/\1/g")
IASCABLE_MINOR_VERSION=$(iascable --version | sed -E "s/^[0-9]+[.]([0-9]+)[.][0-9]+/\1/g")

if [[ "${IASCABLE_MAJOR_VERSION}" -le 2 ]] && [[ "${IASCABLE_MINOR_VERSION}" -lt 14 ]]; then
  echo "Installed iascable cli is backlevel version"
  echo "  Update iascable with this command: curl -sL https://raw.githubusercontent.com/cloud-native-toolkit/iascable/main/install.sh | sh" >&2
  exit 1
fi

cp -R -L "${SCRIPT_DIR}/files/"* "${TARGET_DIR}"

for dir in 1-quickstart 2-standard 3-advanced; do
  if [[ ! -d "${SCRIPT_DIR}/${dir}" ]]; then
    echo ""
    echo "*** No automation provided for infrastructure flavor: ${dir}"
    echo ""
    continue
  else
    echo ""
    echo "*** Generating infrastructure flavor: ${dir}"
    echo ""
  fi

  mkdir -p "${TARGET_DIR}/${dir}"

  boms=""
  while read bom; do
    iascable build -i "${bom}" -o "${TARGET_DIR}/${dir}" --flatten
  done <<< "$(find "${SCRIPT_DIR}/${dir}" -maxdepth 1 -name "*.yaml" | sort)"

  cp -R -L "${SCRIPT_DIR}/${dir}/files/"* "${TARGET_DIR}/${dir}"
  if [[ -d ${SCRIPT_DIR}/${dir}/files/.mocks ]]; then
    cp -R -L "${SCRIPT_DIR}/${dir}/files/.mocks/"* "${TARGET_DIR}/${dir}/.mocks"
  fi

  find "${TARGET_DIR}/${dir}" \( -name "apply.sh" -o -name "destroy.sh" \) | while read path; do
    file=$(basename "${path}")

    cp "${SCRIPT_DIR}/files/${file}" "${path}"
  done
done
