# Maximo Application Suite (MAS) - Deployment

This folder contains instructions for deployment of the Maximo Application Suite Core Automation for AWS, Azure and IBM Cloud using the automation built from a Bill Of Materials (BOM).

The automation modules install the latest versions of the following:

- MAS Core
- Mongo Community
- IBM Suite License Service
- IBM Behavior Analytics Service
- IBM Cert Manager

### Pre-requisites
Ensure the following before continuing
- Github account exists
- A Github [token](https://docs.github.com/en/enterprise-server@3.3/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) is available with permissions set to create and remove repositories
- You are able to login to the OpenShift cluster and obtain an OpenShift login token
- Cloud Pak entitlement key, this can be obtained from visiting the [IBM Container Library](https://myibm.ibm.com/products-services/containerlibrary)

## Quick Start

The Quick Start install provides common, pre-configured values for the platform of choice.  

Change to the directory location of the automation and run the `launch.sh` script

```shell
cd ~/automation/
./launch.sh
```

If this is your first time running the automation, this will download a container pre-configured with the automation clis needed for installation.

After the download completes, change into the maximo gitops directory as below and run the `apply.sh` script.

```shell
cd 406-gitops-cp-maximo
./apply.sh
```

At this point you wil be prompted for your github account information, and some basic maximo application suite information.  This information will be saved in a yaml file in the current directory for later use.

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


At this point the install will automatically progress.  When complete you will see a message that the Apply is complete with approximately 64 resources added, 0 changed, 0 destroyed.  This will take approximately 5-10 minutes.

The Maximo Application Suite will continue for approximately another 20 minutes while it sets up MAS and all the components for MAS-Core.  From this point you can skip to the MAS suite setup steps in the [README](./README.md#setup) below.

## Standard / Advanced

For a Standard or Advanced setup, you may want to edit the pre-configured variables to fit your own customized environment.  To do this you can find the pre-configured variables in the `variables.tf` file located in the directory tree below:

```bash
~/automation/
├── 400-gitops-ocp-maximo
│   ├── apply.sh
│   ├── bom.yaml
│   ├── dependencies.dot
│   ├── destroy.sh
│   └── terraform
│       ├── 400-gitops-ocp-maximo.auto.tfvars
│       ├── docs
│       │   ├── gitops-bootstrap.md
│       │   ├── gitops-cp-bas.md
│       │   ├── gitops-cp-catalogs.md
│       │   ├── gitops-cp-maximo.md
│       │   ├── gitops-cp-sls.md
│       │   ├── gitops-cp-mongo-ce-operator.md
│       │   ├── gitops-cp-mongo-ce.md
│       │   ├── gitops-namespace.md
│       │   ├── gitops-repo.md
│       │   ├── ocp-login.md
│       │   └── sealed-secret-cert.md
│       │   └── util-clis.md
│       ├── main.tf
│       ├── providers.tf
│       └── variables.tf
│       └── version.tf
└── launch.sh

```

Also if you are familiar with terraform and would like to more control over the automation you can start and run the automation by editing the `400-gitops-ocp-maximo.auto.tfvars` and directly invoking terraform such as:

```shell
cd ~/automation/
./launch.sh
```

From the container that is started change into the directory where the automation variables are and run terraform as you would like such as:

```shell
cd /400-gitops-ocp-maximo/terraform
terraform init
terraform apply -auto-approve
```

At this point the install will automatically progress.  When complete you will see a message that the Apply is complete with approximately 64 resources added, 0 changed, 0 destroyed.  This will take approximately 5-10 minutes.

The Maximo Application Suite will continue for approximately another 20 minutes while it sets up MAS and all the components for MAS-Core.  From this point you can skip to the MAS suite setup steps in the [README](./README.md#setup) below.

## Setup

The initial setup for MAS is done through the web console and can be found in the location:

`https://admin.${YourDomainURL}/initialsetup`

NOTE: Depending on the browser you may have to import the self-signed certificate into your keystore (if on a mac)

Login as super user with credential found in the secret named: `{masInstanceID}-credentials-superuser` in the OpenShift project named: `mas-{masInstanceID}-core`  

