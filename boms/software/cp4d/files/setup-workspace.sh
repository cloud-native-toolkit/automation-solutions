#!/bin/bash

# IBM GSI Ecosystem Lab

Usage()
{
   echo "Creates a workspace folder and populates it with automation bundles you require."
   echo
   echo "Usage: setup-workspace.sh"
   echo "  options:"
   echo "  -p     Cloud provider (aws, azure, ibm)"
   echo "  -s     Storage (portworx or odf)"
   echo "  -n     (optional) prefix that should be used for all variables"
   echo "  -x     (optional) Portworx spec file - the name of the file containing the Portworx configuration spec yaml"
   echo "  -c     (optional) Self-signed Certificate Authority issuer CRT file"
   echo "  -h     Print this help"
   echo
}

CLOUD_PROVIDER=""
STORAGE=""
PREFIX_NAME=""
STORAGEVENDOR=""
CA_CRT_FILE=""



if [[ "$1" == "-h" ]]; then
  Usage
  exit 1
fi

# Get the options
while getopts ":p:s:n:h:x:c:" option; do
   case $option in
      h) # display Help
         Usage
         exit 1;;
      p)
         CLOUD_PROVIDER=$OPTARG;;
      s) # Enter a name
         STORAGE=$OPTARG;;
      n) # Enter a name
         PREFIX_NAME=$OPTARG;;
      x) # Enter a name
         PORTWORX_SPEC_FILE=$OPTARG;;
      c) # Enter a name
         CA_CRT_FILE=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         Usage
         exit 1;;
   esac
done

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)
WORKSPACES_DIR="${SCRIPT_DIR}/../workspaces"
WORKSPACE_DIR="${WORKSPACES_DIR}/current"


if [[ -z "${CLOUD_PROVIDER}" ]]; then
  PS3="Select the cloud provider: "

  select provider in aws azure ibm; do
    if [[ -n "${provider}" ]]; then
      CLOUD_PROVIDER="${provider}"
      break
    fi
  done

  echo ""
fi

if [[ ! "${CLOUD_PROVIDER}" =~ ^aws|azure|ibm ]]; then
  echo "Invalid value for cloud provider: ${CLOUD_PROVIDER}" >&2
  exit 1
fi

if [[ -z "${STORAGE}" ]] && [[ "${CLOUD_PROVIDER}" == "ibm" ]]; then
  PS3="Select the storage provider: "

  select storage in portworx odf; do
    if [[ -n "${storage}" ]]; then
      STORAGE="${storage}"
      break
    fi
  done

  echo ""
elif [[ -z "${STORAGE}" ]]; then
  STORAGE="portworx"
fi

if [[ ! "${STORAGE}" =~ ^odf|portworx ]]; then
  echo "Invalid value for storage provider: ${STORAGE}" >&2
  exit 1
fi

if [[ -n "${PREFIX_NAME}" ]]; then
  PREFIX_NAME="${PREFIX_NAME}-"
fi

if [[ -d "${WORKSPACE_DIR}" ]]; then
  DATE=$(date "+%Y%m%d%H%M")
  mv "${WORKSPACE_DIR}" "${WORKSPACES_DIR}/workspace-${DATE}"

  cp "${SCRIPT_DIR}/terraform.tfvars" "${WORKSPACES_DIR}/workspace-${DATE}/terraform.tfvars"
fi

mkdir -p "${WORKSPACE_DIR}"
cd "${WORKSPACE_DIR}"

echo "Setting up workspace in '${WORKSPACE_DIR}'"
echo "*****"

if [[ "${CLOUD_PROVIDER}" == "aws" ]]; then
  RWO_STORAGE="gp2"
elif [[ "${CLOUD_PROVIDER}" == "azure" ]]; then
  RWO_STORAGE="managed-premium"
elif [[ "${CLOUD_PROVIDER}" == "ibm" ]] || [[ "${CLOUD_PROVIDER}" == "ibmcloud" ]]; then
  RWO_STORAGE="ibmc-vpc-block-10iops-tier"
else
  RWO_STORAGE="<your block storage on aws: gp2, on azure: managed-premium>"
fi

if [[ "${STORAGE}" == "portworx" ]]; then
  RWX_STORAGE="portworx-db2-rwx-sc"
  STORAGEVENDOR="portworx"
elif [[ "${STORAGE}" == "odf" ]]; then
  RWX_STORAGE="ocs-storagecluster-cephfs"
  STORAGEVENDOR="ocs"
else
  RWX_STORAGE="<read-write-many storage class (e.g. )>"
  STORAGEVENDOR="RWX-storage-class"
fi

if [[ -z "${PREFIX_NAME}" ]]; then
  echo -n "Provide a prefix name: "
  read -r PREFIX_NAME
fi

if [[ "${CLOUD_PROVIDER}" =~ aws|azure ]] && [[ -z "${PORTWORX_SPEC_FILE}" ]]; then
  if command -v oc 1> /dev/null 2> /dev/null; then
    echo "Looking for existing portworx storage class: ${RWX_STORAGE}"

    if ! oc login "${TF_VAR_server_url}" --token="${TF_VAR_cluster_login_token}" --insecure-skip-tls-verify=true 1> /dev/null; then
      exit 1
    fi

    if oc get storageclass "${RWX_STORAGE}" 1> /dev/null 2> /dev/null; then
      echo "  Found existing portworx installation. Skipping storage layer..."
      echo ""
      PORTWORX_SPEC_FILE="installed"
    fi
  fi

  if [[ -z "${PORTWORX_SPEC_FILE}" ]]; then
    DEFAULT_FILE=$(find . -name "portworx*.yaml" -maxdepth 1 -exec basename {} \; | head -1)

    while [[ -z "${PORTWORX_SPEC_FILE}" ]]; do
      echo -n "Provide the Portworx config spec file name: [${DEFAULT_FILE}] "
      read -r PORTWORX_SPEC_FILE

      if [[ -z "${PORTWORX_SPEC_FILE}" ]] && [[ -n "${DEFAULT_FILE}" ]]; then
        PORTWORX_SPEC_FILE="${DEFAULT_FILE}"
      fi
    done
    echo ""
  fi
elif [[ "${CLOUD_PROVIDER}" == "ibm" ]]; then
  PORTWORX_SPEC_FILE=""
fi

if [[ -n "${PORTWORX_SPEC_FILE}" ]] && [[ "${PORTWORX_SPEC_FILE}" != "installed" ]] && [[ ! -f "${SCRIPT_DIR}/${PORTWORX_SPEC_FILE}" ]]; then
  echo "Portworx spec file not found: ${PORTWORX_SPEC_FILE}" >&2
  exit 1
fi

if [[ "${CLOUD_PROVIDER}" == "ibm" ]]; then
  CA_CRT_FILE=""
fi

if [[ -n "${CA_CRT_FILE}" ]] && [[ ! -f "${SCRIPT_DIR}/${CA_CRT_FILE}" ]]; then
  echo "CA Issuer CRT file not found: ${CA_CRT_FILE}" >&2
  exit 1
fi

cat "${SCRIPT_DIR}/terraform.tfvars.template" | \
  sed "s/PREFIX/${PREFIX_NAME}/g" | \
  sed "s/RWX_STORAGE/${RWX_STORAGE}/g" | \
  sed "s/RWO_STORAGE/${RWO_STORAGE}/g" | \
  sed "s/STORAGEVENDOR/${STORAGEVENDOR}/g" | \
  sed "s/PORTWORX_SPEC_FILE/${PORTWORX_SPEC_FILE}/g" | \
  sed "s/CA_CRT_FILE/${CA_CRT_FILE}/g" \
  > "${SCRIPT_DIR}/terraform.tfvars"

ln -s "${SCRIPT_DIR}/terraform.tfvars" ./terraform.tfvars

cp "${SCRIPT_DIR}/apply-all.sh" "${WORKSPACE_DIR}/apply-all.sh"
cp "${SCRIPT_DIR}/destroy-all.sh" "${WORKSPACE_DIR}/destroy-all.sh"

WORKSPACE_DIR=$(cd "${WORKSPACE_DIR}"; pwd -P)

if [[ "${PORTWORX_SPEC_FILE}" == "installed" ]]; then
  ALL_ARCH="200|300|305|310|315|320"
else
  ALL_ARCH="200|210|300|305|310|315|320"
fi

echo "Setting up workspace in ${WORKSPACE_DIR}"
echo "*****"

mkdir -p "${WORKSPACE_DIR}"

PORTWORX_SPEC_FILE_BASENAME=$(basename "${PORTWORX_SPEC_FILE}")

if [[ -n "${PORTWORX_SPEC_FILE}" ]] && [[ "${PORTWORX_SPEC_FILE}" != "installed" ]]; then
  cp "${SCRIPT_DIR}/${PORTWORX_SPEC_FILE}" "${WORKSPACE_DIR}/${PORTWORX_SPEC_FILE_BASENAME}"
fi

CA_CRT_FILE_BASENAME=$(basename "${CA_CRT_FILE}")

if [[ -n "${CA_CRT_FILE}" ]]; then
  cp "${SCRIPT_DIR}/${CA_CRT_FILE}" "${WORKSPACE_DIR}/${CA_CRT_FILE_BASENAME}"
fi

find ${SCRIPT_DIR}/. -type d -maxdepth 1 | grep -vE "[.][.]/[.].*" | grep -v workspace | sort | \
  while read dir;
do

  name=$(echo "$dir" | sed -E "s/.*\///")

  if [[ ! -d "${SCRIPT_DIR}/${name}/terraform" ]]; then
    continue
  fi

  if [[ ! "${name}" =~ ${ALL_ARCH} ]]; then
    continue
  fi

  if [[ -n "${STORAGE}" ]] && [[ -n "${CLOUD_PROVIDER}" ]]; then
    BOM_STORAGE=$(grep -E "^ +storage" "${SCRIPT_DIR}/${name}/bom.yaml" | sed -E "s~[^:]+: [\"']?(.*)[\"']?~\1~g")
    BOM_PROVIDER=$(grep -E "^ +platform" "${SCRIPT_DIR}/${name}/bom.yaml" | sed -E "s~[^:]+: [\"']?(.*)[\"']?~\1~g")

    if [[ -n "${BOM_PROVIDER}" ]] && [[ "${BOM_PROVIDER}" != "${CLOUD_PROVIDER}" ]]; then
      echo "  Skipping ${name} because it does't match ${CLOUD_PROVIDER}"
      continue
    fi

    if [[ -n "${BOM_STORAGE}" ]] && [[ "${BOM_STORAGE}" != "${STORAGE}" ]]; then
      echo "  Skipping ${name} because it doesn't match ${STORAGE}"
      continue
    fi
  fi

  echo "Setting up current/${name} from ${name}"

  mkdir -p ${name}
  cd "${name}"

  cp -R "${SCRIPT_DIR}/${name}/bom.yaml" .
  cp -R "${SCRIPT_DIR}/${name}/terraform/"* .
  ln -s "${WORKSPACE_DIR}"/terraform.tfvars ./terraform.tfvars
  if [[ -n "${PORTWORX_SPEC_FILE_BASENAME}" ]]; then
    ln -s "${WORKSPACE_DIR}/${PORTWORX_SPEC_FILE_BASENAME}" "./${PORTWORX_SPEC_FILE_BASENAME}"
  fi
  if [[ -n "${CA_CRT_FILE_BASENAME}" ]]; then
    ln -s "${WORKSPACE_DIR}/${CA_CRT_FILE_BASENAME}" "./${CA_CRT_FILE_BASENAME}"
  fi

  cd - > /dev/null
done

echo "move to ${WORKSPACE_DIR} this is where your automation is configured"