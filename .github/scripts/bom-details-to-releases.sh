#!/usr/bin/env bash

BOM_DETAILS="$1"

if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "jq not installed" &>2
  exit 1
fi

if [[ -z "${BOM_DETAILS}" ]]; then
  BOM_DETAILS=$(</dev/stdin)
fi

BOM_LINES=$(echo "${BOM_DETAILS}" | jq -c '.[]')

RELEASES="[]"

for bom in $BOM_LINES; do
  name=$(echo "${bom}" | jq -r '.name')
  version=$(echo "${bom}" | jq -r '.version')
  file=$(echo "${bom}" | jq -r '.file')
  release_name=$(echo "${bom}" | jq -r '.release_name')

  echo "Processing ${name} bom from ${file}" &>2
  echo "  Checking for release: ${release_name}" &>2
  if ! gh release view "${release_name}" 1> /dev/null 2> /dev/null; then
    echo "    Skipping: existing release found!" &>2
    continue
  fi

  echo "  Creating tag: ${release_name}" &>2
  git tag -a "${release_name}" -m "${version} release of ${name} bom" 1> /dev/null
  git push --tags 1> /dev/null

  mkdir -p "/tmp/asset/${name}" 1> /dev/null
  cp "${file}" "/tmp/asset/${name}/bom.yaml" 1> /dev/null

  echo "  Creating release: ${release_name}" &>2
  gh release create \
    "${release_name}" \
    --title "${release_name}" \
    --notes "${version} release of ${name} bom" \
    "/tmp/asset/${name}/bom.yaml" 1> /dev/null || continue

  echo "Release created: ${release_name}" &>2
  RELEASES=$(echo "${RELEASES}" | jq --argjson bom "${bom}" '. += [$bom]')
done

rm -rf /tmp/asset

echo "${RELEASES}"
