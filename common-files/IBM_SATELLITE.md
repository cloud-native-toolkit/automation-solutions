# IBM Cloud Satellite

IBM Cloud Satellite requires specific pre-requisites to be performed before deploying IBM Cloud Paks on Satellite-managed ROKS Clusters across the Distributed Cloud, running in Satellite location on-prem or other clouds including AWS, Azure of GCP or other local Data center provider’s location or at the Edge location.

## Pre-requisites:

The following pre-requisites need to be met before Deploying IBM Cloud Paks onto ROKS clusters running in any Satellite location:

1. Satellite location is created and in normal state.
2. Satellite location includes minimum of 6 hosts:
    - 3 hosts of 16x64 profile assigned to Satellite location control plane
    - Additional 3 hosts of 16x64 for worked nodes to be used by ROKS cluster
3. ROKS cluster is deployed and running in normal state
4. Deployed ODF and storage cluster is in Ready state
    - Block storage is added using local or remote (ex EBS) 
    - Created storage configuration using Satellite storage template
    - Assigned storage configuration to ROKS cluster running in that Satellite location
    - CP4D will be deployed onto this ROKS cluster where ODF storage cluster is running
    - Optionally ODF may use different worker nodes but not necessary for demo and PoC purposes.
    - For production and targeted MVP, separate worker nodes dedicated to ODF storage cluster is recommended.
5. Make sure a Default storage classes is defined 
    > ⚠️ CAUTION: If this step is missed, deployment of the Cloud Pak will fail at Postgres or gitea app deployment in creating PVCs.
    - Make sure this storage class is available `ocs-storagecluster-cephfs` 
    - Annotate `ocs-storagecluster-cephfs` to be default storage class
    - Go to OCP console from browser, click on storage class and click on annotations (pencil icon)
    - Type in for Key = storageclass.kubernetes.io/is-default-class
    - Type in for Value = true
    - Save
    - Now in storage classes `ocs-storagecluster-cephfs` should have Default next to it
6. ROKS cluster can be accessed both from IBM Cloud CLI and well as from the browser.
    - ROKS cluster is configured for public access for demo pr PoC purposes
    - Or there is a connection available to private network to access ROKS cluster over private network.
7. Deploying Cloud Paks using this specific method does not necessarily require an Image Registry to be configured on ROKS cluster, but it may be required for other workloads or other methods such as cpd-cli to deploy CP4D

## Reference Architecture:

IBM Cloud Satellite [Reference architectures](https://ibm-satellite.github.io/academy-labs/#/handbook) are provided for each target infrastructure including AWS, Azure, GCP or on-prem using VMWare. Table below also provides links to instructions on how to create Satellite locations and meet pre-requisite steps specific to target infrastructure.
NOTE: Instructions below include steps to create Satellite locations using TechZone, but you can use any env to create Satellite location.

| Instructions | AWS | Azure | GCP | On-prem using VMWare |
| --- | --- | --- | --- | -- |
| Create Satellite Location and Install Red Hat OpenShift on IBM Cloud | [AWS](https://ibm-satellite.github.io/academy-labs/#/aws/aws-prework) | [Azure](https://ibm-satellite.github.io/academy-labs/#/azure/azure-prework) | TBD | [VMWare on-prem](https://ibm-satellite.github.io/academy-labs/#/vmware/vmware-prework) |
| Review status of Satellite location and cluster | [common](https://ibm-satellite.github.io/academy-labs/#/common/healthstatus/readme) | [common](https://ibm-satellite.github.io/academy-labs/#/common/healthstatus/readme) |  | [common](https://ibm-satellite.github.io/academy-labs/#/common/healthstatus/readme) |
| Expose OpenShift Cluster to public internet | [link](https://ibm-satellite.github.io/academy-labs/#/aws/aws-access-roks-inet) | [link](https://ibm-satellite.github.io/academy-labs/#/aws/aws-access-roks-inet) | TBD | N/A (Private Only) |
| Configure OCP Image registry using IBM CoS | [common](https://ibm-satellite.github.io/academy-labs/#/common/cos-image-registry/readme) | [common](https://ibm-satellite.github.io/academy-labs/#/common/cos-image-registry/readme) | TBD | [common](https://ibm-satellite.github.io/academy-labs/#/common/cos-image-registry/readme) |
| Configure ODF | [link](https://ibm-satellite.github.io/academy-labs/#/aws/aws-odf-ebs) | [link](https://ibm-satellite.github.io/academy-labs/#/azure/azure-odf) |  | [link](https://ibm-satellite.github.io/academy-labs/#/vmware/wmware-odf) | 



## Deploying in a Satellite Cluster

When running the automation, after you have run the `setup-workspace.sh` script, delete all `210*` folders from the `/workspace/current` directory *before* running the `apply-all.sh` script.   This will skip any additional storage configuration when the `apply-all.sh` script is executed, as the Satellite cluster already has ODF deployed, and already has a default `ocs-storagecluster-cephfs` storage class.