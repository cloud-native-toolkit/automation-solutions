#!/usr/bin/env bash

# Script for loading BOMs into Ascent
# "https://<deployed-cluster-url>/architectures/boms/import?overwrite=true&public=true"

TOKEN="$1"
URL="https://ascent-bff-mapper-staging.dev-mapper-ocp-4be51d31de4db1e93b5ed298cdf6bb62-0000.eu-de.containers.appdomain.cloud"

if [[ -z "${TOKEN}" && -z "${URL}"  ]]; then
  echo "usage: load-ascent.sh ASCENT_TOKEN TARGET_URL"
  exit 1
fi

TOKEN="Authorization: Bearer ${TOKEN}"
CURDIR=$(pwd)

files="/aws/_common/gitops/200-aws-openshift-gitops.yaml \
/aws/_common/storage/210-aws-portworx-storage.yaml \
/aws/openshift/1-quickstart/105-aws-vpc-openshift.yaml \
/aws/openshift/1-quickstart/105-aws-vpc-openshift.yaml \
/aws/openshift/1-quickstart/105-aws-vpc-openshift.yaml \
/aws/openshift/1-quickstart/105-aws-vpc-openshift.yaml \
/aws/openshift/2-standard/110-aws-vpc-edge-standard.yaml \
/aws/openshift/2-standard/115-aws-vpc-openshift-standard.yaml \
/aws/openshift/3-advance/110-aws-prod-edge-vpc-advance.yaml \
/aws/openshift/3-advance/115-aws-vpc-openshift-advance.yaml \
/azure/_common/storage/210-azure-portworx-storage.yaml \
/azure/openshift/1-quickstart/110-azure-ocp-ipi.yaml \
/azure/openshift-upi/1-quickstart/105-azure-vnet-openshift.yaml \
/azure/openshift/1-quickstart/105-azure-ocp-ipi.yaml \
/azure/openshift/1-quickstart/110-acme-certificate.yaml \
/azure/openshift/1-quickstart/110-azure-byo-certificate.yaml \
/azure/openshift/1-quickstart/210-azure-portworx-storage.yaml \
/azure/openshift-upi/1-quickstart/105-azure-vnet-openshift.yaml \
/azure/openshift-upi/1-quickstart/200-azure-openshift-gitops.yaml \
/azure/openshift-upi/1-quickstart/210-azure-portworx-storage.yaml \
/ibmcloud/_common/gitops/200-ibm-openshift-gitops.yaml \
/ibmcloud/_common/storage/210-ibm-odf-storage.yaml \
/ibmcloud/_common/storage/210-ibm-portworx-storage.yaml \
/ibmcloud/openshift/1-quickstart/105-ibm-vpc-openshift.yaml \
/ibmcloud/openshift/1-quickstart/200-ibm-openshift-gitops.yaml \
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
/ibmcloud/openshift/3-advanced/220-dev-tools.yaml \
/ibmcloud/openshift-fs/000-ibm-fs-account-setup.yaml \
/ibmcloud/openshift-fs/100-ibm-fs-shared-services.yaml \
/ibmcloud/openshift-fs/110-ibm-fs-edge-vpc.yaml \
/ibmcloud/openshift-fs/120-ibm-fs-management-vpc.yaml \
/ibmcloud/openshift-fs/130-ibm-fs-management-vpc-openshift.yaml \
/ibmcloud/openshift-fs/140-ibm-fs-workload-vpc.yaml \
/ibmcloud/openshift-fs/150-ibm-fs-workload-vpc-openshift.yaml \
/ibmcloud/openshift-fs/160-ibm-fs-openshift-dev-tools.yaml \
/ibmcloud/openshift-fs/165-ibm-fs-openshift-workload.yaml \
/ibmcloud/openshift-fs/170-ibm-fs-openshift-gitops.yaml  \
/ibmcloud/zos-dev/000-ibm-zdev-account-setup.yaml \
/ibmcloud/zos-dev/100-ibm-zdev-shared-services.yaml \
/ibmcloud/zos-dev/110-ibm-zdev-network-vpc.yaml \
/ibmcloud/zos-dev/120-ibm-zdev-development-vpc.yaml \
/ibmcloud/zos-dev/130-ibm-zdev-development-vpc-openshift.yaml \
/ibmcloud/zos-dev/160-ibm-zdev-openshift-dev-tools.yaml "

for loadfile in ${files[@]}; do
  echo $str

    file='=@"'${CURDIR}$loadfile'"'
    echo $file
    curl --location --request POST "${URL}/architectures/boms/import?overwrite=true&public=true" \
      --header "${TOKEN}"  --form "${file}"
    echo "\n"

done
