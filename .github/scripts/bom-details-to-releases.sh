#!/usr/bin/env bash

REPO="${1:-github.com/cloud-native-toolkit/automation-solutions}"

if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "jq not installed" 1>&2
  exit 1
fi

BOM_DETAILS=$(</dev/stdin)

RELEASES="[]"

while read -r bom; do
  name=$(echo "${bom}" | jq -r '.name')
  version=$(echo "${bom}" | jq -r '.version')
  file=$(echo "${bom}" | jq -r '.file')
  release_name=$(echo "${bom}" | jq -r '.release_name')

  echo "Processing ${name} bom from ${file}" 1>&2
  echo "  Checking for release: ${release_name}" 1>&2
  if gh release view "${release_name}" --repo "${REPO}" --json name 1> /dev/null 2> /dev/null; then
    echo "    Skipping: existing release found!" 1>&2
    continue
  fi

  echo "  Creating tag: ${release_name}" 1>&2
  git tag -a "${release_name}" -m "${version} release of ${name} bom" 1> /dev/null 2> /dev/null
  git push --tags 1> /dev/null 2> /dev/null

  mkdir -p "/tmp/asset/${name}" 1> /dev/null
  cp "${file}" "/tmp/asset/${name}/bom.yaml" 1> /dev/null

  echo "  Creating release: ${release_name}" 1>&2
  gh release create \
    "${release_name}" \
    --title "${release_name}" \
    --notes "${version} release of ${name} bom" \
    --repo "${REPO}" \
    "/tmp/asset/${name}/bom.yaml" 1> /dev/null 2> /dev/null || continue

  echo "Release created: ${release_name}" 1>&2
  RELEASES=$(echo "${RELEASES}" | jq --argjson bom "${bom}" '. += [$bom]')
done < <(echo "${BOM_DETAILS}" | jq -c '.[]')

rm -rf /tmp/asset

echo "${RELEASES}"
