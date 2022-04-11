# Azure - OCP Cluster Storage

Read-write-many (RWX) storage is required for many types of software deployments, including IBM Cloud Pak for Data, IBM Maximo Application Suite, and more.

The automation for RedHat OpenShift on Azure supports two storage mechanisms:

- Portworx Storage
- OpenShift Data Foundation (ODF) **Coming Soon**

Either one of these solutions can satisfy the RWX storage access modes for StorageClass instances created within your OpenShift cluster.

# Deploying

To enable RWX StorageClass access modes within your cluster, you need to deploy at least one of the two storage modules.  Both can be installed side by side, but it is recommended to only install one storage mechanism.

## Portworx Storage:

Portworx is a widely-used and reliable cloud-native storage solution for production workloads and provides high-availability, data protection and security for containerized applications.

Portworx is available in 2 flavors: Enterprise and Essentials.

- Portworx Essentials is free forever, but only supports a maximum of 5 nodes on a cluster, 200 volumes, and 5TB of storage.
- Portworx Enterprise requires a subscription (has 30 day free trial), supports over 1000 nodes per cluster, and has unlimited storage.

To deploy Portworx on AWS you must specify a portworx configuration:

More detailed comparisons are available at: https://portworx.com/products/features/

Instructions for obtaining your portworx configuration are available at:

- [Portworx Essentials](https://github.com/cloud-native-toolkit/terraform-azure-portworx/blob/main/PORTWORX_ESSENTIALS.md)
- [Portworx Enterprise](https://github.com/cloud-native-toolkit/terraform-azure-portworx/blob/main/PORTWORX_ENTERPRISE.md)

To deploy Portworx storage:

- `cd` into the `210-portworx-storage` folder.
- Modify the `terraform/210-portworx-storage.auto.tfvars` file to includethe cluster name, resource group, kubeconfig file, and a valid portworx configuration (including `px_generated_cluster_id`, `user_id` and `osb_endpoint` from the Portworx configurator):

  ```
  ## azure-portworx_cluster_name: The name of the ARO cluster
  azure-portworx_cluster_name="toolkit-dev-aro"
  
  ## azure-portworx_region: Azure Region the cluster is deployed in
  #azure-portworx_region="aro-toolkit-dev"
  
  ## azure-portworx_resource_group_name: Resource group where cluster is deployed
  #azure-portworx_resource_group_name=""
  
  ## azure-portworx_portworx_config: Portworx configuration
  #azure-portworx_portworx_config={
    cluster_id = "px-cluster-43940d51-874e-49d3-8892-XXXXXXXX"
    user_id = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    osb_endpoint = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    type = "essentials"
    enable_encryption = false
  }
  
  ## azure-portworx_cluster_config_file: Cluster config file for Kubernetes cluster.
  azure-portworx_cluster_config_file=".kubeconfig"
  ```

- Execute the `apply.sh` script


## ODF Storage:

Red Hat® OpenShift® Data Foundation—previously Red Hat OpenShift Container Storage—is software-defined storage for containers. Engineered as the data and storage services platform for Red Hat OpenShift, Red Hat OpenShift Data Foundation helps teams develop and deploy applications quickly and efficiently across clouds.

**ODF automation support is coming soon**
