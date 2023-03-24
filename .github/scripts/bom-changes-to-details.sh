#!/usr/bin/env bash

CHANGED_BOMS="$1"

if ! command -v yq 1> /dev/null 2> /dev/null; then
  echo "yq not installed" 1>&2
  exit 1
fi
if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "jq not installed" 1>&2
  exit 1
fi

RESULT="[]"

bom_details() {
  local bom="$1"

  name=$(yq e '.metadata.name' "${bom}")
  version=$(yq e '.spec.version // "v1.0.0"' "${bom}")
  display_name=$(yq e '.metadata.annotation.displayName // ""' "${bom}")
  description=$(yq e '.metadata.annotation.description // ""' "${bom}")
  category=$(yq e '.metadata.labels.type // ""' "${bom}")
  if [[ "${bom}" =~ ^solutions ]]; then
    type="solution"
  else
    type="bom"
  fi

  release_name="${name}_${version}"

  if [[ -z "${display_name}" ]]; then
    display_name="${name}"
  fi
  if [[ -z "${description}" ]]; then
    description="Layer for ${name}"
  fi

  RESULT=$(echo "${RESULT}" | jq --arg name "${name}" --arg file "${bom}" --arg version "${version}" --arg release "${release_name}" --arg displayName "${display_name}" --arg description "${description}" --arg category "${category}" --arg type "${type}" '. += [{"name": $name, "version": $version, "release_name": $release, "display_name": $displayName, "description": $description, "category": $category, "file": $file, "type": $type}]')
}

if [[ -n "${CHANGED_BOMS}" ]]; then
  for bom in $CHANGED_BOMS; do
    bom_details "${bom}"
  done
else
  while read -r bom; do
    bom_details "${bom}"
  done < /dev/stdin
fi

echo "${RESULT}"
