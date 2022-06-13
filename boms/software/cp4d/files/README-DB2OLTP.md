# DB2OLTP Automation for AWS, Azure, and IBM Cloud

### Change Log

- **06/2022** - Initial Release

> The terraform automation layers has been crafted from a set of  [Terraform modules](https://modules.cloudnativetoolkit.dev/) created by the IBM GSI Ecosystem Lab team part of the [IBM Partner Ecosystem organization](https://www.ibm.com/partnerworld/public?mhsrc=ibmsearch_a&mhq=partnerworld). Please contact  **Bala Sivasubramanian** _bala_@us.ibm.com_ for more details or raise an issue on the repository.

The automation will support the installation of DB2OLTP on three cloud platforms (AWS, Azure, and IBM Cloud).  



### Data Fabric Layered Installation

The Data Foundation automation is broken into what we call layers of automation or bundles. The bundles enable SRE activities to be optimized. The automation is generic between clouds other than configuration storage options, which are platform specific. 

| BOM ID | Name                                                                                                                                                                                                                                                           | Description                                                                                                                                                | Run Time |
|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| 310 | [310 - DB2U Operator](./310-cloud-pak-for-data-db2uoperator) | Install DB2U Operator into the cluster | 10 Mins |                                                                    
| 320 | [320 - DB2 OLTP](./320-cloud-pak-for-data-db2oltp) | Install DB2 Warehouse service into the cluster | 15 Mins |                                                                



> At this time the most reliable way of running this automation is with Terraform in your local machine either through a bootstrapped container image or with native tools installed. We provide a Container image that has all the common SRE tools installed. [CLI Tools Image,](https://quay.io/repository/ibmgaragecloud/cli-tools?tab=tags) [Source Code for CLI Tools](https://github.com/cloud-native-toolkit/image-cli-tools)

### Pre-Req Setup

⚠️⚠️ Please install the [Cloud Pak for Data data foundation](README.md) before you proceed with DB2OLTP installation and make sure its success.

The installation process will use a standard GitOps repository that has been built using the Modules to support Data Foundation installation. The automation is consistent across three cloud environments AWS, Azure, and IBM Cloud.

### Installing DB2OLTP with pre-req DB2U Operator

Steps

1. Change directories to the `310-cloud-pak-for-data-db2uoperator` folder and run the following commands to deploy entitlements into your cluster:

    ```
    cd ../310-cloud-pak-for-data-db2uoperator
    terraform init
    terraform apply --auto-approve
    ```
    
    > This step will install DB2U Operator which is Pre-Req for DB2 OLTP Operator.

2. Change directories to the `320-cloud-pak-for-data-db2oltp` folder and run the following commands to deploy entitlements into your cluster:

    ```
    cd ../320-cloud-pak-for-data-db2oltp
    terraform init
    terraform apply --auto-approve
    ```
    
    > This step will install DB2OLTP Operator and instance into cluster. You can login to CP4D Console (Refer Step 30) and verify the service instance. 

### Create DB2OLTP database instance via Manually (⚠️⚠️ Automation coming soon in CPD 4.5 release)

3. You must grant additional privileges to enable the web console to validate the CPU and memory values that you select for your deployment.

To add these privileges, run the following command on the OpenShift® cluster:

    ```
    oc adm policy add-cluster-role-to-user system:controller:persistent-volume-binder system:serviceaccount:${NAMESPACE}:zen-databases-sa

    ```

 ${Namespace} refers where you have created the DB2OLTP instances

After you run the command, the console is able to validate your selections by checking the available number of nodes on the cluster, whether the nodes are properly labeled and tainted, and the amount of available CPU and memory.


4. You can manually create the database for DB2OLTP by following the instructions https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=db2-creating-database-deployment

    > This step will create the database on the cluster using CP4D Console

This will create a database using many of the default values. You can adjust through the process for any resources you wish to change to support your requirements.

Login to cpd console
```   
- From the hamburger menu
    - Data->Databases
      - Create a database
      - Select a database type
      - Click Next

    - Configure
      - Provide a database name
      - Click Next

    - Advance Configuration
      - Page size: 16384
      - Click Next

    - System storage    
      - Storage Class : portworx-db2-rwx-sc
      - Size : 100 GB
      - Access Mode: ReadWriteMany
      - Click Next
      
    - User storage
      - Storage Class : portworx-db2-rwo-sc (RWO with 4K block size)
      - Size : 100 GB
      - Access Mode: ReadWriteOnce
      - Click Next

    - Backup storage
      - Storage Class : portworx-db2-rwx-sc
      - Size : 100 GB
      - Access Mode: ReadWriteMany
      - Click Next

    - Transaction logs storage
      - Storage Class : portworx-db2-rwo-sc (RWO with 4K block size)
      - Size : 100 GB
      - Access Mode: ReadWriteOnce
      - Click Next
      
    - Temporary table spaces storage
      - Storage Class : portworx-db2-rwo-sc (RWO with 4K block size)
      - Size : 100 GB
      - Access Mode: ReadWriteOnce
      - Click Finalize
```  

As a result, Database for DB2OLTP will be created.

### Exposing DB2OLTP Connection on ROKS VPC Gen2 via Load Balancer

Sometimes it can be helpful to setup internet access to the DB2 OLTP pod(s) running in OpenShift on IBM Cloud.  Using your favorite database client you can connect to the database and browse tables, execute queries, etc. 

1.  If you have installed DB2OLTP on IBM Cloud VPC Gen2, follow the [instructions](README-DB2-Expose-External.md)
    
    > The instructions shows how to setup an external route and connect to DB2 from a database client on your laptop.

## Summary

This concludes the instructions for installing *CP4D Data foundation with DB2OLTP* on AWS, Azure, and IBM Cloud.

Now that the Data Foundation deployment is complete you can deploy [Cloud Pak for Data services](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=integrations-services) into this cluster.


## Uninstalling & Troubleshooting

Please refer to the [Troubleshooting Guide](./TROUBLESHOOTING.md) for uninstallation instructions and instructions to correct common issues.

If you continue to experience issues with this automation, please [file an issue](https://github.com/IBM/automation-data-foundation/issues) or reach out on our [public Dischord server](https://discord.com/channels/955514069815808010/955514069815808013).

