## Get an OpenShift IPI cluster running on Azure

### Prereqs

1. [Configure Azure DNS](https://github.com/openshift/installer/blob/d0f7654bc4a0cf73392371962aef68cd9552b5dd/docs/user/azure/dnszone.md).
   1. In this example it will be referred as `clusters.azure.example.com`, set up in a resource group called `ocp-ipi-rg`.
2. [Create a Service Principal](https://github.com/openshift/installer/blob/d0f7654bc4a0cf73392371962aef68cd9552b5dd/docs/user/azure/credentials.md) with proper IAM roles.
3. Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
4. Get your [OpenShift installer pull secret](https://console.redhat.com/openshift/install/pull-secret) and save it in `./pull-secret`.
5. Clone OpenShift IPI on Azure terraform automation module from @ncolon:
    ```
    $ git clone https://github.com/NoeSamaille/terraform-openshift4-azure
    $ cd terraform-openshift4-azure
    ```
6. Create your `terraform.tfvars` file, similar to:
    ```tfvars
    azure_region = "eastus"
    cluster_name = "ocp-48-maximo"

    # From Prereq. Step #1
    base_domain = "clusters.azure.example.com"
    azure_base_domain_resource_group_name = "ocp-ipi-rg"

    # From Prereq. Step #2
    azure_subscription_id  = "<REPLACE_azure_subscription_id>"
    azure_tenant_id        = "<REPLACE_azure_tenant_id>"
    azure_client_id        = "<REPLACE_azure_client_id>"
    azure_client_secret    = "<REPLACE_azure_client_secret>"

    # Custom config
    openshift_version="4.8.33"

    worker_count=6 # Maximo sizing
    azure_worker_vm_type="Standard_D16s_v5"
    ```
7. Run terraform (takes 15-30mins to complete):
   ```bash
    terraform init
    terraform plan
    terraform apply
    ```
8. Access your cluster:
    ```bash
    $ export KUBECONFIG=$PWD/installer-files/auth/kubeconfig
    $ oc get nodes
    NAME                                       STATUS   ROLES    AGE     VERSION
    ocp-48-maximo-5boq2-master-0               Ready    master   3h13m   v1.21.6+4b61f94
    ocp-48-maximo-5boq2-master-1               Ready    master   3h13m   v1.21.6+4b61f94
    ocp-48-maximo-5boq2-master-2               Ready    master   3h13m   v1.21.6+4b61f94
    ocp-48-maximo-5boq2-worker-eastus1-474t2   Ready    worker   3h4m    v1.21.6+4b61f94
    ocp-48-maximo-5boq2-worker-eastus1-68wzn   Ready    worker   3h4m    v1.21.6+4b61f94
    ocp-48-maximo-5boq2-worker-eastus2-s5b9k   Ready    worker   3h5m    v1.21.6+4b61f94
    ocp-48-maximo-5boq2-worker-eastus2-wfrsr   Ready    worker   3h5m    v1.21.6+4b61f94
    ocp-48-maximo-5boq2-worker-eastus3-fn2j9   Ready    worker   3h6m    v1.21.6+4b61f94
    ocp-48-maximo-5boq2-worker-eastus3-lvjfv   Ready    worker   3h4m    v1.21.6+4b61f94
    ```
9. Replace OpenShift default ingress certificates (required to access the console: [Documentation](https://docs.openshift.com/container-platform/4.8/security/certificates/replacing-default-ingress-certificate.html))
    ```bash
    # Clone terraform-certs-letsencrypt
    $ cd ..
    $ git clone https://github.com/ncolon/terraform-certs-letsencrypt
    $ cd terraform-certs-letsencrypt

    # Create your tfvars file
    $ cat <<EOF > terraform.tfvars
    dns_provider = "azure"
    app_subdomain = "apps.ocp-48-maximo.clusters.azure.example.com"

    letsencrypt_api_endpoint = "https://acme-v02.api.letsencrypt.org/directory"
    letsencrypt_email = "<REPLACE_letsencrypt_email>"

    azure_resource_group   = "ocp-ipi-rg"
    azure_subscription_id  = "<REPLACE_azure_subscription_id>"
    azure_tenant_id        = "<REPLACE_azure_tenant_id>"
    azure_client_id        = "<REPLACE_azure_client_id>"
    azure_client_secret    = "<REPLACE_azure_client_secret>"
    EOF

    # Run terraform
    $ terraform init
    $ terraform plan
    $ terraform apply

    # Get Certificates
    $ terraform output --raw router_cert > router.crt
    $ terraform output --raw router_key > router.key
    $ terraform output --raw router_ca > router-ca.crt

    # Create a config map that includes only the root CA certificate used to sign the wildcard certificate
    $ oc create configmap custom-ca \
        --from-file=ca-bundle.crt=router-ca.crt \
        -n openshift-config
    # Update the cluster-wide proxy configuration with the newly created config map
    $ oc patch proxy/cluster \
        --type=merge \
        --patch='{"spec":{"trustedCA":{"name":"custom-ca"}}}'
    # Create a secret that contains the wildcard certificate chain and key
    $ oc create secret tls letsencrypt-certs \
        --cert=router.crt \
        --key=router.key \
        -n openshift-ingress
    $ oc patch ingresscontroller.operator default \
        --type=merge -p \
        '{"spec":{"defaultCertificate": {"name": "letsencrypt-certs"}}}' \
        -n openshift-ingress-operator
    ```
10. Replace OpenShift default API server certificates (required to log it with the CLI without bypassing certificate check: [Documentation](https://docs.openshift.com/container-platform/4.8/security/certificates/api-server.html))
    ```bash
    # Create your tfvars file
    $ cat <<EOF > terraform.tfvars
    dns_provider = "azure"
    app_subdomain = "api.ocp-48-maximo.clusters.azure.example.com"

    letsencrypt_api_endpoint = "https://acme-v02.api.letsencrypt.org/directory"
    letsencrypt_email = "<REPLACE_letsencrypt_email>"

    azure_resource_group   = "ocp-ipi-rg"
    azure_subscription_id  = "<REPLACE_azure_subscription_id>"
    azure_tenant_id        = "<REPLACE_azure_tenant_id>"
    azure_client_id        = "<REPLACE_azure_client_id>"
    azure_client_secret    = "<REPLACE_azure_client_secret>"
    EOF

    # Run terraform
    $ terraform init
    $ terraform plan
    $ terraform apply

    # Get Certificates
    $ terraform output --raw router_cert > router.crt
    $ terraform output --raw router_ca >> router.crt
    $ terraform output --raw router_key > router.key

    # Create a secret that contains the certificate chain and private key in the openshift-config namespace
    $ oc create secret tls api-server-certs \
        --cert=router.crt \
        --key=router.key \
        -n openshift-config
    # Update the API server to reference the created secret.
    $ oc patch apiserver cluster \
        --type=merge -p \
        '{"spec":{"servingCerts": {"namedCertificates":
        [{"names": ["<FQDN>"], 
        "servingCertificate": {"name": "api-server-certs"}}]}}}'
    ```
    - **Note**: replace `<FQDN>` in this example it would be `api.ocp-48-maximo.clusters.azure.example.com`.

That's it, you should now have a runnning IPI cluster with valid TLS certificates for default ingress and API server!
