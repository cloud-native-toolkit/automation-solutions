#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

TARGET_DIR="$1"

if [[ -z "${TARGET_DIR}" ]]; then
  echo "usage: generate.sh TARGET_DIR"
  exit 1
fi

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
    boms="${boms} -i ${bom}"
  done <<< "$(find "${SCRIPT_DIR}/${dir}" -name "*.yaml" -maxdepth 1 | sort)"

  iascable build ${boms} -o "${TARGET_DIR}/${dir}" --flatten

  cp -R -L "${SCRIPT_DIR}/${dir}/files/"* "${TARGET_DIR}/${dir}"
  if [[ -d ${SCRIPT_DIR}/${dir}/files/.mocks ]]; then
    cp -R -L "${SCRIPT_DIR}/${dir}/files/.mocks/"* "${TARGET_DIR}/${dir}/.mocks"
  fi
done
