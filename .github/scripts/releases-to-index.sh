#!/usr/bin/env bash

INDEX_FILE="${1:-index.yaml}"

if ! command -v yq 1> /dev/null 2> /dev/null; then
  echo "yq not installed" &>2
  exit 1
fi

if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "jq not installed" &>2
  exit 1
fi

RELEASES=$(</dev/stdin)

BASE_URL="https://github.com/cloud-native-toolkit/automation-solutions/releases/download"

INDEX_JSON=$(yq '.' -o json "${INDEX_FILE}")

while read -r release; do
  name=$(echo "${release}" | jq -r '.name')
  version=$(echo "${release}" | jq -r '.version')
  release_name=$(echo "${release}" | jq -r '.release_name')
  display_name=$(echo "${release}" | jq -r '.display_name')
  description=$(echo "${release}" | jq -r '.description')
  category=$(echo "${release}" | jq -r '.category')

  release_url="${BASE_URL}/${release_name}/bom.yaml"

  version_json=$(jq -n -c --arg version "${version}" --arg url "${release_url}" '{"version": $version, "metadataUrl": $url}')

  release_json=$(echo "${INDEX_JSON}" | jq --arg name "${name}" -c '.boms[] | select(.name == $name)')
  if [[ -n "${release_json}" ]]; then
    versions=$(echo "${release_json}" | jq -c --argjson version "${version_json}" '.versions | reverse | . += [$version] | reverse')

    release_json=$(echo "${release_json}" | jq -c --argjson versions "${versions}" '.versions = $versions')

    INDEX_JSON=$(echo "${INDEX_JSON}" | jq --arg name "${name}" --argjson bom "${release_json}" '(.boms[] | select(.name == $name)) |= $bom')
  else
    release_json=$(jq -n -c --arg name "${name}" --arg displayName "${display_name}" --arg description "${description}" --arg category "${category}" --argjson version "${version_json}" '{"name": $name, "displayName": $displayName, "description": $description, "type": "bom", "versions": [$version]}')

    INDEX_JSON=$(echo "${INDEX_JSON}" | jq --arg name "${name}" --argjson bom "${release_json}" '.boms += [$bom]')
  fi

done < <(echo "${RELEASES}" | jq -c '.[]')

echo "${INDEX_JSON}" | yq -P '.' -
