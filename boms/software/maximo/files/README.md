# Maximo Application Suite - Core Automation for AWS, Azure, and IBM Cloud

### Change Log

- **04/2022** - Initial Release

> This collection of Maximo Core IBM Cloud terraform automation layers has been crafted from a set of  [Terraform modules](https://modules.cloudnativetoolkit.dev/) created by the IBM GSI Ecosystem Lab team part of the [IBM Partner Ecosystem organization](https://www.ibm.com/partnerworld/public?mhsrc=ibmsearch_a&mhq=partnerworld). Please contact **Matthew Perrins** _mjperrin@us.ibm.com_, **Sean Sundberg** _seansund@us.ibm.com_, **Tom Skill** _tskill@us.ibm.com_,  or **Andrew Trice** _amtrice@us.ibm.com_ for more details or raise an issue on the repository.

The automation will support the installation of Maximo Core on three cloud platforms (AWS, Azure, and IBM Cloud).

### Target Infrastructure

The Maximo Core automation assumes you have an OpenShift cluster already configured on your cloud of choice. The supported managed options are [ROSA for AWS](https://aws.amazon.com/rosa/), [ARO for Azure](https://azure.microsoft.com/en-us/services/openshift/) or [ROKS for IBM Cloud ](https://www.ibm.com/cloud/openshift).

Before you start to install and configure Maximo Core, you will need to identify what your target infrastructure is going to be. You can start from scratch and use one of the pre-defined reference architectures from IBM or bring your own.

### Reference Architectures

The reference architectures are provided in three different forms, with increasing security and associated sophistication to support production configuration. These three forms are as follows:

- **Quick Start** - a simple architecture to quickly get an OpenShift cluster provisioned
- **Standard** - a standard production deployment environment with typical security protections, private endpoints, VPN server, key management encryption, etc
- **Advanced** - a more advanced deployment that employs network isolation to securely route traffic between the different layers.

For each of these reference architecture, we have provided a detailed set of automation to create the environment for the software. If you do not have an OpenShift environment provisioned, please use one of these. They are optimized for the installation of this solution.

| Cloud Platform                                                                                                            | Automation and Documentation                                                                                                                                                                                  |   
|---------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [IBM Cloud](https://cloud.ibm.com)                                                                                        | [IBM Cloud Quick Start](https://github.com/IBM/automation-ibmcloud-infra-openshift/tree/initial-version) </br> [IBM Cloud Standard](https://github.com/IBM/automation-ibmcloud-infra-openshift/tree/standard) |  
| [AWS](https://aws.amazon.com/)                                                                                            | [AWS Quick Start](https://github.com/IBM/automation-aws-infra-openshift/tree/1-quick-start) </br> [AWS Standard - Coming soon]()                                                                              |
| [Azure](https://portal.azure.com/#home)                                                                                   | [Azure Quick Start - Coming soon]()                                                                                 |                                                                                             | 
| Bring You Own Infrastructure                                                                                              | You will need to setup GitOps and Storage details on the following steps                                                                                                                                        /

### Getting Started

Within this repository you will find a set of Terraform template bundles that embody best practices for provisioning Maximo Core in multiple cloud environments. This `README.md` describes the SRE steps required to provision the Maximo Core software.

This suite of automation can be used for a Proof of Technology environment, or used as a foundation for production workloads with a fully working end-to-end cloud-native environment. The software installs using **GitOps** best practices with [**Red Hat Open Shift GitOps**](https://docs.openshift.com/container-platform/4.8/cicd/gitops/understanding-openshift-gitops.html)

## Maximo Core Architecture

The following reference architecture represents the logical view of how Maximo Core works after it is installed. After obtaining a license key you will need to register your data sources. They can range from other Kubernetes environment to VMWare and Virtual Machines.

![Reference Architecture](./maximo-arch.png)

## Deploying Maximo Core

The following instructions will help you install Maximo Core into AWS, Azure, and IBM Cloud OpenShift Kubernetes environment.

### Obtaining License Key

To use Maximo Core you are required to install a license key. For Proof of Concepts IBM Partners and IBMers can obtain it using the steps highlighted below.

⚠️ todo: update for mas core

[//]: # (#### Partners)

[//]: # (For Partners follow these steps:)

[//]: # ()
[//]: # (1. For PoCs/PoTs, Partners can download a license key from [Partner World Software Catalog]&#40;https://www.ibm.com/partnerworld/program/benefits/software-access-catalog&#41;)

[//]: # (2. You can search the software catalog for  **M05C4EN	IBM Turbonomic Application Resource Management On-Prem 8.4.6 for install on Kubernetes English**,)

[//]: # (3. Download the package which contains license file for Turbonomic, with a name similar to `CP4MCM_IBM_ARM_OEM_Premier_License_July_2022.lic`)

[//]: # (5. This file is covered by **Turbonomic ARM P/N are currently available under IBM PPA terms and conditions**)

[//]: # ()
[//]: # (#### IBMers)

[//]: # ()
[//]: # (For IBMers you can download a license key using these steps:)

[//]: # ()
[//]: # (1. Go to [XL Leverage]&#40;https://w3-03.ibm.com/software/xl/download/ticket.wss&#41;)

[//]: # (2. Search with keyword: turbonomic)

[//]: # (3. Select the package **M05C4EN	IBM Turbonomic Application Resource Management On-Prem 8.4.6 for install on Kubernetes English** and download)

[//]: # (4. Extract this download package to get the turbonomic license key)

[//]: # (   This package contains license file for turbonomic, with a name similar to “CP4MCM_IBM_ARM_OEM_Premier_License_July_2022.lic)

### Maximo Core for Multi Cloud

The Maximo Core automation is broken into what we call layers of automation or bundles. The bundles enable SRE activities to be optimized. The automation is generic between clouds other than setting Storage for IBM Cloud. That was broken into a separate automation layer.

| BOM ID | Name                                                         | Description                                                                                                                                                                                                                                   | Run Time |
|--------|--------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| 200    | [200 - OpenShift Gitops](./200-openshift-gitops)             | Set up OpenShift GitOps in ROSA, ARO or ROKS, this is required to install the software using gitops only use this if you are bringing your own OpenShift Cluster which has not been provisioned from the reference architectures listed above | 10 Mins  |
| 202    | [210-ibm-portworx-storage](./210-ibm-portworx-storage)          | If you are installing into your own ROKS clusters on IBM Cloud you will need to use this automation bundle to configure IBM Cloud Storage class before installing Maximo Core                                                                  | 10 Mins |
| 250 | [400 - Maximo Core - Multi Cloud](./400-mas-core-multicloud) | Provision Maximo Core into Multi Cloud environment AWS, Azure and IBM Cloud supported                                                                                                                                                         | 10 Mins  |


> At this time the most reliable way of running this automation is with Terraform in your local machine either through a bootstrapped container image or with native tools installed. We provide a Container image that has all the common SRE tools installed. [CLI Tools Image,](https://quay.io/repository/ibmgaragecloud/cli-tools?tab=tags) [Source Code for CLI Tools](https://github.com/cloud-native-toolkit/image-cli-tools)

## Installation Steps

Before you start the installation please install the pre-req tools on your machine.

> We have tested this on a modern Mac laptop. We are testing on M1 machines. You will need to setup the tools natively in your M1 Mac OS and not run the `launch.sh` script.

### Pre-Req Setup

Please install the following Pre-Req tools to help you get started with the SRE tasks for installing Maximo Core into an existing OpenShift Cluster on AWS, Azure, or IBM Cloud.

Pre-requisites:
- Check you have a valid GitHub ID that can be used to create a repository in your own organization [GitHub]( https://github.com/) or GitHub Enterprise account.
- Install a code editor, we recommend [Visual Studio Code](https://code.visualstudio.com/)
- Install [Brew](https://brew.sh/)
- Install a **Colima** a replacement for Docker Desktop , [Colima](https://github.com/abiosoft/colima)
   ```
   brew install colima
   ```

Ensure the following before continuing
- Github account exists
- A Github [token](https://docs.github.com/en/enterprise-server@3.3/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) is available with permissions set to create and remove repositories
- You are able to login to the OpenShift cluster and obtain an OpenShift login token
- Cloud Pak entitlement key, this can be obtained from visiting the [IBM Container Library](https://myibm.ibm.com/products-services/containerlibrary)

### Installing Maximo Core

The installation process will use a standard GitOps repository that has been built using the Modules to support Maximo Core installation. The automation is consistent across three cloud environments AWS, Azure, and IBM Cloud.

Steps:

1. First step is to clone the automation code to your local machine. Run this git command in your favorite command line shell.

     ```
     git clone git@github.com:IBM/automation-maximo-app-suite.git
     ```
2. Navigate into the `automation-maximo-app-suite` folder using your command line.
   a.	The README.md has a comprehensive instructions on how to install this into other cloud environments than TechZone. This document focuses on getting it running in a TechZone requested environment.
3. Next you will need to set-up your credentials.properties file. This will enable a secure access to your cluster.

    ```
    cp credentials.template credentials.properties
    code credential.properties
    ```

    ```
    # Add the values for the Credentials to access the IBM Cloud
    # Instructions to access this information can be found in the README.MD
    # This is a template file and the ./launch.sh script looks for a file based on this template named credentials.properties
    TF_VAR_gitops_repo_username=
    TF_VAR_gitops_repo_token=
    TF_VAR_cluster_login_token=
    TF_VAR_server_url=
    ```

4. You will need to populate these values. Add your Git Hub username and your Personal Access Token to `repo_username` and `repo_token`
5. From you OpenShift console click on top right menu and select Copy login command and click on Display Token
6. Copy the API Token value into the `login_token` value
7. Copy the Server URL into the `server_url` value, only the part starting with https
8. You need to make sure you are not running Docker Desktop as this is not allowed under their new terms and conditions for corporate use. You need to install **Colima** as an alternative

    ```
    brew install colima
    colima start
    ```

9. We are now ready to start installing Maximo Core, run the `launch.sh` command, make sure you are in the root of the automation-maximo-app-suite repository

   ```
   ./launch.sh
   Cleaning up old container: cli-tools-WljCg
   Initializing container cli-tools-WljCg from quay.io/cloudnativetoolkit/terraform:v1.1
   Attaching to running container...
   /terraform $
   ```

10. **launch.sh** will download a container image that contains all the command line tools to enable easy installation of the software. Once it has downloaded, it will mount the local file system and exec into the container for you to start running commands from within this custom container.

> we expect partners and clients will use their own specific **Continuous Integration** tools to support this the IBM team has focused on getting it installed in the least complicated way possible

11. Next step is to create a workspace to run the Terraform automation.
12. Run the command setup-workspace.sh

```
./setup-workspace.sh
``` 

13. The default `terraform.tfvars` file is symbolically linked to the new `workspaces/current` folder so this enables you to edit the file in your native operating system using your editor of choice.
14. Edit the default `terraform.tfvars` file this will enable you to setup the GitOps parameters.

The following are variables that you will be prompted for and some suggested values.

| Variable      | Description  | Suggested Value | 
| -----------   | ------------ | ---------------
| gitops-repo_host | The host for the git repository.  | github.com    |
| gitops-repo_type | The type of the hosted git repository (github or gitlab). | github |
| gitops-repo_org | The org/group where the git repository exists | github userid or org |
| gitops-repo_repo | The short name of the repository to create | gitops-mas-ibmcloud |
| gitops-repo_username | The username of the user with access to the repository | github userid |
| gitops-repo_token | The git personal access token | BFe4k0MFK9s5RGIt... |
| bas_dbpassword | Password for BAS database | password |
| bas_grafanapassword | Password for BAS grafana database | password |
| entitlement_key | CloudPak Entitlement Key | eyJhbGciOiJIUzI1NiJ9.eyJpc3... |
| cluster_ingress | Ingress of the Cluster | masdemo.us-east-container.appdomain.cloud |
| gitops-cp-maximo_instanceid | Instance name for MAS - for example: masdemo or mas8 | mas8 |
| sls-namespace_name | Namespace for IBM SLS | ibm-sls |
| mongo-namespace_name | Namespace for Mongo | mongo |
| bas-namespace_name | Namespace for BAS | masbas |
| server_url | Url fo the OpenShift cluster | https://c100-e.us-east.containers.cloud.ibm.com:32346 |
| cluster_login_token | OpenShift cluster login token | sha256~nlXiXCYO_kEydz36B88y0reQ... |

15. Change the `storage_class_name` value to `managed_premium` for **Azure** and other values for AWS. If we are on IBM Cloud you will need to run the `202` automation to configure Storage for the IBM Cloud environment.
16. You will see that the `repo_type` and `repo_host` are set to GitHub you can change these to other Git Providers, like GitHub Enterprise or GitLab.
17. For the `repo_org` value set it to your default org name, or specific a custom org value. This is the organization where the GitOps Repository will be created in. Click on top right menu and select Your Profile to take you to your default organization.
18. Set the `repo_repo` value to a unique name that you will recognize as the place where the GitOps configuration is going to be placed before Maximo Core is installed into the cluster.
19. You can change the Banner text to something useful for your client project or demo.
20. Save the `terraform.tfvars` file
21. Navigate into the `/workspaces/current` folder
22. Navigate into the `200` folder and run the following commands

      ```
      cd 200-openshift-gitops
      terraform init
      terraform apply --auto-approve
      ………
      Apply complete! Resources: 78 added, 0 changed, 0 destroyed.

      ```

23. This will kick off the automation for setting up the GitOps Operator into your cluster.

24. You can check the progress by looking at two places, first look in your github repository. You will see the git repository has been created based on the name you have provided. The Maximo Core install will populate this with information to let OpenShift GitOps install the software. The second place is to look at the OpenShift console, Click Workloads->Pods and you will see the GitOps operator being installed.

25. If you are using IBM Cloud, navigate into the 202 folder and run the following commands, this will configure the storage correctly for IBM Cloud. If you are installing on AWS or Azure you can skip this step and move to the 250 installation of Maximo Core.

⚠️ todo: update for mas core
 ```
 cd 202-turbonomic-ibmcloud-storage-class
 terraform init
 terraform apply --auto-approve
 ```

26.	Now that the GitOps is installed in the cluster, and we have bound the git repository to OpenShift GitOps operator. We are now ready to populate this with some Software configuration that cause OpenShift GitOps to install the software into the cluster. Navigate into the `250` folder and run the following commands, this will install Turbonomic into the cluster.

⚠️ todo: update for mas core
 ```
 cd 250-turbonomic-multicloud
 terraform init
 terraform apply --auto-approve
 ………
 Apply complete! Resources: 38 added, 0 changed, 0 destroyed.
 ```

27. Once the installation has finished you will see a message from Terraform defining the state of the environment.
28. You will see the first change as a purple banner describing what was installed

[//]: # (29. The next step is to validate if everything has installed correctly. Open your git repository where your git ops configuration was defined.)

[//]: # ()
[//]: # (30. Check if the payload folder has been created with the correct definitions for GitOps. Navigate to the `payload/2-services/namespace/turbonomic` folder and look at the content of the installation YAML files. You should see the Operator CR definitions)

[//]: # ()
[//]: # (⚠️ todo: update for mas core)

[//]: # ()
[//]: # (31. Final Step is to Open up Argo CD &#40;OpenShift GitOps&#41; check it is correctly configured, click on the Application menu 3x3 Icon on the header and select **Cluster Argo CD** menu item.)

[//]: # ()
[//]: # (32. Complete the authorization with OpenShift, and, then narrow the filters by selecting the **turbonomic namespace**.)

[//]: # ()
[//]: # (⚠️ todo: update for mas core)

[//]: # ()
[//]: # (33. This will show you the GitOps dashboard of the software you have installed using GitOps techniques)

[//]: # (34. Click on **turbonomic-turboinst** tile)

[//]: # (35.)

[//]: # (⚠️ todo: update for mas core)

[//]: # ()
[//]: # (36. You will see all the microservices that Turbonomic uses to install with their enablement state)



At this point the install will automatically progress.  When complete you will see a message that the Apply is complete with approximately 64 resources added, 0 changed, 0 destroyed.  This will take approximately 5-10 minutes.

The Maximo Application Suite will continue for approximately another 20 minutes while it sets up MAS and all the components for MAS-Core.  From this point you can skip to the MAS suite setup steps in the [README](./README.md#setup) below.


### Setup Maximo Core after installation

The initial setup for MAS is done through the web console and can be found in the location:

`https://admin.${YourDomainURL}/initialsetup`

NOTE: Depending on the browser you may have to import the self-signed certificate into your keystore (if on a mac)

Login as super user with credential found in the secret named: `{masInstanceID}-credentials-superuser` in the OpenShift project named: `mas-{masInstanceID}-core`


## Summary

This concludes the instructions for installing *Maximo Core* on AWS, Azure, and IBM Cloud

## Troubleshooting

Currently there are no troubleshooting topics.

## How to Generate this repository from teh source Bill of Materials.

This set of automation packages was generated using the open-source [`isacable`](https://github.com/cloud-native-toolkit/iascable) tool. This tool enables a [Bill of Material yaml](https://github.com/cloud-native-toolkit/automation-solutions/tree/main/boms/software/maximo) file to describe your software requirements. If you want up stream releases or versions you can use `iascable` to generate a new terraform module.

> The `iascable` tool is targeted for use by advanced SRE developers. It requires deep knowledge of how the modules plug together into a customized architecture. This repository is a fully tested output from that tool. This makes it ready to consume for projects.
