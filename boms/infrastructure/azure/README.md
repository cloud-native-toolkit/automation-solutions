# Azure Reference Architecture - Automation

> This collection of IBM Cloud terraform automation bundles has been crafted from a set of [Terraform modules](https://modules.cloudnativetoolkit.dev/) created by the IBM Ecosystem Labs team part of the [IBM Ecosystem organization](https://www.ibm.com/partnerworld/public?mhsrc=ibmsearch_a&mhq=partnerworld). Please contact **Matthew Perrins** __mjperrin@us.ibm.com__, **Sean Sundberg** __seansund@us.ibm.com__, or **Andrew Trice** __amtrice@us.ibm.com__ for more details or raise an issue on the [repository](https://github.com/cloud-native-toolkit/software-everywhere) for bugs or feature requests.

Three different flavors of the reference architecture are provided with different levels of complexity.

- QuickStart - minimum to get OpenShift with public endpoints running on basic VPC + Subnet with ROKS
- Standard - a simple robust architecture that can support a production workload in a single VPC with a VPN+Private Endpoints and a ROKS cluster
- Advanced - a sophisticated architecture isolating DMZs, Development and Production VPCs for best practices

## Reference architectures

This set of automation packages was generated using the open-source [`isacable`](https://github.com/cloud-native-toolkit/iascable) tool. This tool enables a [Bill of Material yaml](https://github.com/cloud-native-toolkit/automation-solutions/tree/main/boms) file to describe your IBM Cloud architecture, which it then generates the terraform modules into a package of infrastructure as code that you can use to accelerate the configuration of your IBM Cloud environment. Iascable generates standard terraform templates that can be executed from any terraform environment.

> The `iascable` tool is targeted for use by advanced SRE developers. It requires deep knowledge of how the modules plug together into a customized architecture. This repository is a fully tested output from that tool. This makes it ready to consume for projects.

### Quick Start

![QuickStart](1-quickstart/architecture.png)

### Standard

TBD

### Advanced

TBD

## Automation

### Prerequisites

1. Owner and User Access Administrator roles in an Azure Subscription. The user must be able to create a service principal per the below prerequisite.
1. [Configure Azure DNS](https://github.com/openshift/installer/blob/d0f7654bc4a0cf73392371962aef68cd9552b5dd/docs/user/azure/dnszone.md).
   1. In this example it will be referred as `clusters.azure.example.com`, set up in a resource group called `ocp-ipi-rg`.
2. [Create a Service Principal](https://github.com/openshift/installer/blob/d0f7654bc4a0cf73392371962aef68cd9552b5dd/docs/user/azure/credentials.md) with proper IAM roles.
3. Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
4. Get your [OpenShift installer pull secret](https://console.redhat.com/openshift/install/pull-secret). Save for use in the terraform variables file later.

2. (Optional) Install and start Colima to run the terraform tools in a local bootstrapped container image.

    ```shell
    brew install docker colima
    colima start
    ```

### Planning

1. Determine which flavor of reference architecture you will provision: Quick Start, Standard, or Advanced.
2. View the README in the automation directory for detailed instructions for installation steps and required information:
    - [Quick Start](1-quickstart)
    - [Standard](2-standard)
    - [Advanced](3-advanced)

### Setup

1. Clone this repository to your local SRE laptop or into a secure terminal. Open a shell into the cloned directory.
2. Copy **credentials.template** to **credentials.properties**.
    ```shell
    cp credentials.template credentials.properties
    ```
3. Provide values for the variables in **credentials.properties** (**Note:** `*.properties` has been added to **.gitignore** to ensure that the file containing the apikey cannot be checked into Git.)
    - **TF_VAR_subscription_id** - The Azure subscription into which to deploy the cluster.
    - **TF_VAR_tenant_id** - The Azure tenant id that owns the subscription.
    - **TF_VAR_client_id** - The service principal id (appID) with Owner and User Access Administrator roles in the subscription
    - **TF_VAR_client_secret** - The password for the service principal.
    - **TF_VAR_pull_secret** - The contents of the Red Hat OpenShift pull secret downloaded in the prerequisites.
4. Run **./launch.sh**. This will start a container image with the prompt opened in the `/terraform` directory, pointed to the repo directory.
5. Create a working copy of the terraform by running **./setup-workspace.sh**. The script makes a copy of the terraform in `/workspaces/current` and set up a "terraform.tfvars" file populated with default values. The **setup-workspace.sh** script has a number of optional arguments.

    ```
    Usage: setup-workspace.sh [-s STORAGE] [-r REGION] [-n PREFIX_NAME]
    
    where:
      - **STORAGE** - The storage provider. Possible options are `portworx` or `odf`. If not provided as an argument, a prompt will be shown.
      - **REGION** - the Azure location where the infrastructure will be provided ([available regions](https://docs.microsoft.com/en-us/azure/availability-zones/az-overview)). If not provided the value defaults to `eastus`
      - **PREFIX_NAME** - the name prefix that should be added to all the resources. If not provided a prefix will not be added.
    ```
6. Change the directory to the current workspace where the automation was configured (e.g. `/workspaces/current`).
7. Inspect **terraform.tfvars** to see if there are any variables that should be changed. (The **setup-workspace.sh** script has generated **terraform.tfvars** with default values and can be used without updates, if desired.)

    **Note:** A soft link has been created to the **terraform.tfvars** in each of the terraform subdirectories so the configuration is shared between all of them. 

#### Run all the terraform layers automatically

From the **/workspace/current** directory, run the following:

```
./apply-all.sh
```

The script will run through each of the terraform layers in sequence to provision the entire infrastructure.

#### Run all the terraform layers manually

From the **/workspace/current** directory, run change directory into each of the layer subdirectories and run the following:

```shell
terraform init
terraform apply -auto-approve
```
