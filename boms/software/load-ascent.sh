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

files="/datafabric/600-datafabric-multicloud.yaml \
/devtools/220-dev-tools.yaml \
/gitops/201-gitops-bootstrap.yaml \
/gitops/200-openshift-gitops-bootstrap.yaml \
/integration/200-openshift-gitops.yaml \
/integration/210-ibm-odf-storage.yaml \
/integration/220-integration-apiconnect.yaml \
/integration/230-integration-mq.yaml \
/integration/240-integration-ace.yaml \
/integration/250-integration-eventstreams-TBD.yaml \
/integration/260-integration-mq-uniform-cluster.yaml \
/integration/280-integration-platform-multicloud.yaml \
/maximo/200-openshift-gitops.yaml \
/maximo/210-aws-portworx-storage.yaml \
/maximo/210-azure-portworx-storage.yaml \
/maximo/210-ibm-odf-storage.yaml \
/maximo/210-ibm-portworx-storage.yaml \
/maximo/400-mas-core-multicloud.yaml \
/maximo/405-mas-manage.yaml \
/telco-cloud/500-telco-all.yaml \
/telco-cloud/500-telco-core.yaml \
/telco-cloud/500-telco-data.yaml \
/telco-cloud/500-telco-integration.yaml \
/security/700-cp4s-multicloud.yaml
/turbonomic/200-openshift-gitops.yaml \
/turbonomic/202-turbonomic-ibmcloud-storage-class.yaml \
/turbonomic/250-turbonomic-multicloud.yaml"

for loadfile in ${files[@]}; do
  echo $str

    file='=@"'${CURDIR}$loadfile'"'
    echo $file
    curl --location --request POST ${URL} \
      --header "${TOKEN}"  --form "${file}"
    echo "\n"

done

