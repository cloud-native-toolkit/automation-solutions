#!/bin/bash

# IBM GSI Ecosystem Lab

Usage()
{
   echo "Creates a workspace folder and populates it with automation bundles you require."
   echo
   echo "Usage: setup-workspace.sh"
   echo "  options:"
   echo "  -p     Cloud provider (aws, azure, ibm)"
   echo "  -n     (optional) prefix that should be used for all variables"
   echo "  -c     (optional) Self-signed Certificate Authority issuer CRT file"
   echo "  -b     (optional) the banner text that should be shown at the top of the cluster"
   echo "  -g     (optional) the git host that will be used for the gitops repo. If left blank gitea will be used by default. (Github, Github Enterprise, Gitlab, Bitbucket, Azure DevOps, and Gitea servers are supported)"
   echo "  -h     Print this help"
   echo
}

CLOUD_PROVIDER=""
PREFIX_NAME="cp4d"
CA_CRT_FILE=""
GIT_HOST=""
BANNER="Cloud Pak for Data"



if [[ "$1" == "-h" ]]; then
  Usage
  exit 1
fi

# Get the options
while getopts ":p:n:h:c:g:b:" option; do
   case $option in
      h) # display Help
         Usage
         exit 1;;
      p)
         CLOUD_PROVIDER=$OPTARG;;
      n) # Enter a name
         PREFIX_NAME=$OPTARG;;
      c) # Enter a name
         CA_CRT_FILE=$OPTARG;;
      g) # Enter a name
         GIT_HOST=$OPTARG;;
      b) # Enter a name
         BANNER=$OPTARG;;
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

if [[ ! "${CLOUD_PROVIDER}" =~ ^ibm ]]; then
  echo "This automation expects OpenShift Data Foundation (ODF) or OpenShift Container Storage (OCS) to be preinstalled on the cluster."
  echo "Is ODF or OCS already deployed on this cluster?"
  read -p "[y/n] " confirm_storage

  if [ $choice != 'y' ] ; then
    echo "Please configure ODF or OCS storage on this cluster and re-run this script."
    exit 1;
  fi
fi

if [[ -n "${PREFIX_NAME}" ]]; then
  PREFIX_NAME="${PREFIX_NAME}-"
fi

if [[ -d "${WORKSPACE_DIR}" ]]; then
  DATE=$(date "+%Y%m%d%H%M")
  mv "${WORKSPACE_DIR}" "${WORKSPACES_DIR}/workspace-${DATE}"

  cp "${SCRIPT_DIR}/cluster.tfvars" "${WORKSPACES_DIR}/workspace-${DATE}/cluster.tfvars"
  cp "${SCRIPT_DIR}/gitops.tfvars" "${WORKSPACES_DIR}/workspace-${DATE}/gitops.tfvars"
  cp "${SCRIPT_DIR}/cp4d.tfvars" "${WORKSPACES_DIR}/workspace-${DATE}/cp4d.tfvars"
fi

mkdir -p "${WORKSPACE_DIR}"
cd "${WORKSPACE_DIR}"

echo "Setting up workspace in '${WORKSPACE_DIR}'"
echo "*****"

if [[ -z "${PREFIX_NAME}" ]]; then
  echo -n "Provide a prefix name: "
  read -r PREFIX_NAME
fi


if [[ "${CLOUD_PROVIDER}" == "ibm" ]]; then
  CA_CRT_FILE=""
fi

if [[ -n "${CA_CRT_FILE}" ]] && [[ ! -f "${SCRIPT_DIR}/${CA_CRT_FILE}" ]]; then
  echo "CA Issuer CRT file not found: ${CA_CRT_FILE}" >&2
  exit 1
fi

cat "${SCRIPT_DIR}/terraform.tfvars.template-cluster" | \
  sed "s/PREFIX/${PREFIX_NAME}/g" | \
  sed "s/CA_CRT_FILE/${CA_CRT_FILE}/g" | \
  sed "s/BANNER/${BANNER}/g"  | \
  sed "s/GIT_HOST/${GIT_HOST}/g" \
  > "${SCRIPT_DIR}/cluster.tfvars"

ln -s "${SCRIPT_DIR}/cluster.tfvars" ./cluster.tfvars

cat "${SCRIPT_DIR}/terraform.tfvars.template-gitops" | \
  sed "s/PREFIX/${PREFIX_NAME}/g" | \
  sed "s/CA_CRT_FILE/${CA_CRT_FILE}/g" | \
  sed "s/BANNER/${BANNER}/g"  | \
  sed "s/GIT_HOST/${GIT_HOST}/g" \
  > "${SCRIPT_DIR}/gitops.tfvars"

ln -s "${SCRIPT_DIR}/gitops.tfvars" ./gitops.tfvars

cat "${SCRIPT_DIR}/terraform.tfvars.template-cp4d" | \
  sed "s/PREFIX/${PREFIX_NAME}/g" | \
  sed "s/CA_CRT_FILE/${CA_CRT_FILE}/g" | \
  sed "s/BANNER/${BANNER}/g"  | \
  sed "s/GIT_HOST/${GIT_HOST}/g" \
  > "${SCRIPT_DIR}/cp4d.tfvars"

ln -s "${SCRIPT_DIR}/cp4d.tfvars" ./cp4d.tfvars

cp "${SCRIPT_DIR}/apply.sh" "${WORKSPACE_DIR}/apply.sh"
cp "${SCRIPT_DIR}/destroy.sh" "${WORKSPACE_DIR}/destroy.sh"
cp "${SCRIPT_DIR}/apply-all.sh" "${WORKSPACE_DIR}/apply-all.sh"
cp "${SCRIPT_DIR}/destroy-all.sh" "${WORKSPACE_DIR}/destroy-all.sh"
cp "${SCRIPT_DIR}/terragrunt.hcl" "${WORKSPACE_DIR}/terragrunt.hcl"
cp "${SCRIPT_DIR}/layers.yaml" "${WORKSPACE_DIR}/layers.yaml"
cp -R "${SCRIPT_DIR}/.mocks" "${WORKSPACE_DIR}/.mocks"

WORKSPACE_DIR=$(cd "${WORKSPACE_DIR}"; pwd -P)

if [[ ! "${CLOUD_PROVIDER}" =~ ^ibm ]]; then
  ALL_ARCH="105|200|300"
else
  ALL_ARCH="105|200|210|300"
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
  ln -s "${WORKSPACE_DIR}"/cluster.tfvars ./cluster.tfvars
  ln -s "${WORKSPACE_DIR}"/gitops.tfvars ./gitops.tfvars
  ln -s "${WORKSPACE_DIR}"/cp4d.tfvars ./cp4d.tfvars
  ln -s "${WORKSPACE_DIR}/apply.sh" ./apply.sh
  ln -s "${WORKSPACE_DIR}/destroy.sh" ./destroy.sh
  if [[ -n "${PORTWORX_SPEC_FILE_BASENAME}" ]]; then
    ln -s "${WORKSPACE_DIR}/${PORTWORX_SPEC_FILE_BASENAME}" "./${PORTWORX_SPEC_FILE_BASENAME}"
  fi
  if [[ -n "${CA_CRT_FILE_BASENAME}" ]]; then
    ln -s "${WORKSPACE_DIR}/${CA_CRT_FILE_BASENAME}" "./${CA_CRT_FILE_BASENAME}"
  fi

  cd - > /dev/null
done

echo "move to ${WORKSPACE_DIR} this is where your automation is configured"