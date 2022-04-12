#!/usr/bin/env bash

# Script for loading BOMs into Ascent
# "https://<deployed-cluster-url>/architectures/boms/import?overwrite=true&public=true"

TOKEN="$1"
URL="$2"

if [[ -z "${TOKEN}" && "${URL}"  ]]; then
  echo "usage: load-ascent.sh ASCENT_TOKEN TARGET_URL"
  exit 1
fi

TOKEN="Authorization: Bearer ${TOKEN}"
CURDIR=$(pwd)

files="/aws/_common/gitops/200-aws-openshift-gitops.yaml \
/aws/_common/storage/210-aws-portworx-storage.yaml \
/aws/openshift/1-quickstart/105-aws-vpc-openshift.yaml \
/azure/_common/gitops/200-azure-openshift-gitops.yaml \
/azure/_common/storage/210-azure-portworx-storage.yaml \
/azure/openshift/1-quickstart/105-azure-vnet-openshift.yaml \
/azure/openshift/1-quickstart/220-dev-tools.yaml \
/ibmcloud/_common/gitops/200-ibm-openshift-gitops.yaml \
/ibmcloud/_common/storage/210-ibm-odf-storage.yaml \
/ibmcloud/_common/storage/210-ibm-portworx-storage.yaml \
/ibmcloud/openshift/1-quickstart/105-ibm-vpc-openshift.yaml \
/ibmcloud/openshift/2-standard/000-ibm-account-setup.yaml \
/ibmcloud/openshift/2-standard/100-ibm-shared-services.yaml \
/ibmcloud/openshift/2-standard/110-ibm-vpc-edge-standard.yaml \
/ibmcloud/openshift/2-standard/115-ibm-vpc-openshift-standard.yaml \
/ibmcloud/openshift/2-standard/200-ibm-openshift-gitops.yaml \
/ibmcloud/openshift/3-advanced/000-ibm-account-setup.yaml \
/ibmcloud/openshift/3-advanced/100-ibm-shared-services.yaml \
/ibmcloud/openshift/3-advanced/110-ibm-edge-vpc.yaml \
/ibmcloud/openshift/3-advanced/130-ibm-development-vpc-openshift.yaml \
/ibmcloud/openshift/3-advanced/150-ibm-production-vpc-openshift.yaml \
/ibmcloud/openshift/3-advanced/200-ibm-openshift-gitops-dev.yaml \
/ibmcloud/openshift/3-advanced/200-ibm-openshift-gitops-integration.yaml \
/ibmcloud/openshift/3-advanced/210-ibm-odf-storage.yaml \
/ibmcloud/openshift/3-advanced/210-ibm-portworx-storage.yaml \
/ibmcloud/openshift/3-advanced/220-dev-tools.yaml"

for loadfile in ${files[@]}; do
  echo $str

    file='=@"'${CURDIR}$loadfile'"'
    echo $file
    curl --location --request POST ${URL} \
      --header "${TOKEN}"  --form "${file}"
    echo "\n"

done
