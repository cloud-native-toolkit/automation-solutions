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



BOMs are the raw ingredients for building automation for complex cloud installations. They are described in `YAML` and  enables automation to be created to deploy infrastructure and software into cloud environments.


GitOps within an AWS ROSA, Azure ARO, IBM Cloud ROKS cluster.

## Standard / Advanced

List of BOMs for Maximo, there is a generic one for full customization. The others have specific setting to enable install into the cloud platform with default storage classes for that platform.  Note that customization is still possible even after the automation is generated.
