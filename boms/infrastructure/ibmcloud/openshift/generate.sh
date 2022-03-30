#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

TARGET_DIR="$1"

if [[ -z "${TARGET_DIR}" ]]; then
  echo "usage: generate.sh TARGET_DIR"
  exit 1
fi

cp -R "${SCRIPT_DIR}/files/"* "${TARGET_DIR}"

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

  mkdir -p "${TARGET_DIR}/automation/${dir}"

  find "${SCRIPT_DIR}/${dir}" -name "*.yaml" -maxdepth 1 | sort | while read bom; do
    iascable build -i "${bom}" -o "${TARGET_DIR}/automation/${dir}"
  done

  cp "${SCRIPT_DIR}/${dir}/files/"* "${TARGET_DIR}/automation/${dir}"
done
