#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)

if [[ "${1}" == "--prompt" ]]; then
  PROMPT_ALL="true"
else
  CI="${1}"
  VARIABLES_FILE="${1}"
fi

if [[ -z "${VARIABLES_FILE}" ]]; then
  VARIABLES_FILE="variables.yaml"
fi

YQ=$(command -v yq4 || command -v yq)
if [[ -z "${YQ}" ]] || [[ $(${YQ} --version | sed -E "s/.*version ([34]).*/\1/g") == "3" ]]; then
  echo "yq v4 is required"
  exit 1
fi

if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "jq is required"
  exit 1
fi

CREDENTIALS_PROPERTIES="../credentials.properties"
TERRAFORM_TFVARS="terraform.tfvars"

if [[ -f "${TERRAFORM_TFVARS}" ]]; then
  cp "${TERRAFORM_TFVARS}" "${TERRAFORM_TFVARS}.backup"
  rm "${TERRAFORM_TFVARS}"
fi

if [[ -f "${CREDENTIALS_PROPERTIES}" ]]; then
  cp "${CREDENTIALS_PROPERTIES}" "${CREDENTIALS_PROPERTIES}.backup"
  rm "${CREDENTIALS_PROPERTIES}"
fi
touch "${CREDENTIALS_PROPERTIES}"

if [[ ! -f "${VARIABLES_FILE}" ]]; then
  echo "Variables can be provided in a yaml file passed as the first argument"
  echo ""
fi

TMP_VARIABLES_FILE="${VARIABLES_FILE}.tmp"

echo "variables: []" > ${TMP_VARIABLES_FILE}

function process_variable () {
  local name="$1"
  local default_value="$2"
  local sensitive="$3"
  local description="$4"
  local prompt_all="$5"

  local variable_name="TF_VAR_${name}"

  if env | grep -q "${variable_name}"; then
    environment_variable=$(env | grep "${variable_name}" | sed -E 's/.*=(.*).*/\1/g')
  else
    environment_variable="null"
  fi
  value="${environment_variable}"
  if [[ -f "${VARIABLES_FILE}" ]]; then
    value=$(cat "${VARIABLES_FILE}" | NAME="${name}" ${YQ} e -o json '.variables[] | select(.name == env(NAME)) | .value' - | jq -c -r '.')
    if [[ "${value}" == "null" ]]; then
      value="${environment_variable}"
    fi
  fi

  if [[ "${value}" == "null" ]] && [[ "${prompt_all}" != "true" ]]; then
    value="${default_value}"
  fi

  echo "  Processing variable: ${name} '${default_value}' '${value}' '${prompt_all}'"

  while [[ "${value}" == "null" ]]; do
    echo "Provide a value for '${name}':"
    if [[ -n "${description}" ]]; then
      echo "  ${description}"
    fi
    sensitive_flag=""
    if [[ "${sensitive}" == "true" ]]; then
      sensitive_flag="-s"
    fi
    default_prompt=""
    if [[ "${default_value}" != "null" ]]; then
      default_prompt="(${default_value}) "
    fi
    read -u 1 ${sensitive_flag} -p "> ${default_prompt}" value
    value=${value:-$default_value}
  done

  output_value=$(echo "${value}" | sed 's/"/\\"/g')

  if [[ "${sensitive}" != "true" ]]; then
    echo "${name} = \"${output_value}\"" >> "${TERRAFORM_TFVARS}"
    if [[ -z "${value}" ]]; then
      NAME="${name}" VALUE="${value}" ${YQ} e -i -P '.variables += [{"name": env(NAME), "value": ""}]' "${TMP_VARIABLES_FILE}"
    else
      NAME="${name}" VALUE="${value}" ${YQ} e -i -P '.variables += [{"name": env(NAME), "value": env(VALUE)}]' "${TMP_VARIABLES_FILE}"
    fi
  else
    echo "export ${name}=\"${output_value}\"" >> "${CREDENTIALS_PROPERTIES}"
  fi
}

cat "bom.yaml" | ${YQ} e '.spec.variables[] | .name' - | while read name; do
  variable=$(cat "bom.yaml" | NAME="${name}" ${YQ} e '.spec.variables[] | select(.name == env(NAME))' -)

  default_value=$(echo "${variable}" | ${YQ} e -o json '.value' - | jq -c -r '.')
  sensitive=$(echo "${variable}" | ${YQ} e '.sensitive // false' -)
  description=$(echo "${variable}" | ${YQ} e '.description // ""' -)

  process_variable "${name}" "${default_value}" "${sensitive}" "${description}" "${PROMPT_ALL}"
done

if [[ -f "${VARIABLES_FILE}" ]]; then
  cat "${VARIABLES_FILE}" | ${YQ} e '.variables[]' -o json - | jq -c '.' | while read var; do
    name=$(echo "${var}" | jq -r '.name')

    value=$(echo "${var}" | jq -r '.value // empty')
    sensitive=$(echo "${var}" | jq -r '.sensitive')

    bom_var=$(cat bom.yaml | ${YQ} e '.spec.variables[]' -o json - | jq --arg NAME "${name}" -c 'select(.name == $NAME)')

    if [[ -z "${bom_var}" ]]; then
      process_variable "${name}" "${value}" "${sensitive}" "" "${PROMPT_ALL}"
    fi
  done
fi

cp "${TMP_VARIABLES_FILE}" "${VARIABLES_FILE}"
rm "${TMP_VARIABLES_FILE}"

# shellcheck source=../credentials.properties
source "${CREDENTIALS_PROPERTIES}"

if [[ -f "${PWD}/terragrunt.hcl" ]]; then
  if [[ -n "${CI}" ]]; then
    NON_INTERACTIVE="--terragrunt-non-interactive"
  fi

  terragrunt run-all apply --terragrunt-parallelism 1 ${NON_INTERACTIVE}
else
  PARALLELISM=6

  find . -type d -maxdepth 1 | grep -vE "[.]/[.].*" | grep -vE "^[.]$" | grep -v workspace | sort | \
    while read dir;
  do
    name=$(echo "$dir" | sed -E "s~[.]/(.*)~\1~g")

    TYPE=$(grep "deployment-type/gitops" ./${name}/bom.yaml | sed -E "s~[^:]+: [\"'](.*)[\"']~\1~g")

    if [[ "${TYPE}" == "true" ]]; then
      PARALLELISM=3
      echo "***** Setting parallelism for gitops type deployment for step ${name} to ${PARALLELISM} *****"
    fi

    OPTIONAL=$(grep "apply-all/optional" ./${name}/bom.yaml | sed -E "s~[^:]+: [\"'](.*)[\"']~\1~g")

    if [[ "${OPTIONAL}" == "true" ]]; then
      echo "***** Skipping optional step ${name} *****"
      continue
    fi

    VPN_REQUIRED=$(grep "vpn/required" ./${name}/bom.yaml | sed -E "s~[^:]+: [\"'](.*)[\"']~\1~g")

    if [[ "${VPN_REQUIRED}" == "true" ]]; then
      RUNNING_PROCESSES=$(ps -ef)
      VPN_RUNNING=$(echo "${RUNNING_PROCESSES}" | grep "openvpn --config")

      if [[ -n "${VPN_RUNNING}" ]]; then
        echo "VPN required but it is already running"
      elif command -v openvpn 1> /dev/null 2> /dev/null; then
        OVPN_FILE=$(find . -name "*.ovpn" | head -1)

        if [[ -z "${OVPN_FILE}" ]]; then
          echo "VPN profile not found. Skipping ${name}"
          continue
        fi

        echo "Connecting to vpn with profile: ${OVPN_FILE}"
        sudo openvpn --config "${OVPN_FILE}" &
      elif [[ -n "${CI}" ]]; then
        echo "VPN connection required but unable to create the connection. Skipping..."
        continue
      else
        echo "Please connect to your vpn instance using the .ovpn profile within the 110-ibm-fs-edge-vpc directory and press ENTER to proceed."
        read throwaway
      fi
    fi

    echo "***** Applying ${name} *****"

    cd "${name}" && \
      terraform init && \
      terraform apply -parallelism=$PARALLELISM -auto-approve && \
      cd - 1> /dev/null || \
      exit 1
  done
fi
