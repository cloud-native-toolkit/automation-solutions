#!/usr/bin/env bash

REPO="${1:-github.com/cloud-native-toolkit/automation-solutions}"

BASE_URL="https://github.com/cloud-native-toolkit/automation-solutions/releases/download"

if ! command -v yq 1> /dev/null 2> /dev/null; then
  echo "yq not installed" 1>&2
  exit 1
fi
if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "jq not installed" 1>&2
  exit 1
fi

TAB=$'\t'
RELEASES=$(gh release list --repo "${REPO}" | grep -v TITLE | sed -E "s/^([^ ${TAB}]+)[ ${TAB}]+.*/\1/g")

RESULT="[]"

bom_details() {
  local bom="$1"

  name=$(yq e '.metadata.name' "${bom}")
  version=$(yq e '.spec.version // "v1.0.0"' "${bom}")
  display_name=$(yq e '.metadata.annotation.displayName // ""' "${bom}")
  description=$(yq e '.metadata.annotation.description // ""' "${bom}")
  category=$(yq e '.metadata.labels.type // ""' "${bom}")
  release_name="${name}_${version}"

  if [[ -z "${display_name}" ]]; then
    display_name="${name}"
  fi
  if [[ -z "${description}" ]]; then
    description="Layer for ${name}"
  fi

  RESULT=$(echo "${RESULT}" | jq --arg name "${name}" --arg file "${bom}" --arg version "${version}" --arg release "${release_name}" --arg displayName "${display_name}" --arg description "${description}" --arg category "${category}" '. += [{"name": $name, "version": $version, "release_name": $release, "display_name": $displayName, "description": $description, "category": $category, "file": $file}]')
}

while read -r release_name; do

  release_url="${BASE_URL}/${release_name}/bom.yaml"

  mkdir -p "/tmp/asset/${release_name}"
  curl -Lso "/tmp/asset/${release_name}/bom.yaml" "${release_url}"

  if ! yq e '.' "/tmp/asset/${release_name}/bom.yaml" 1> /dev/null 2> /dev/null; then
    echo "Failed to parse file: /tmp/asset/${release_name}/bom.yaml" 1>&2
    continue
  fi

  bom_details "/tmp/asset/${release_name}/bom.yaml"

done < <(echo "${RELEASES}")

echo "${RESULT}"
