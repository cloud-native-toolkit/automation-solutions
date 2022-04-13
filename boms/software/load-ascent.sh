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
/integration/300-integration-platform-multicloud.yaml \
/maximo/200-openshift-gitops.yaml \
/maximo/400-mas-core-multicloud.yaml \
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

