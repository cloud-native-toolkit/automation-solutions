# Maximo Application Suite (MAS) - Deployment

This folder contains instructions for deployment of the Maximo Application Suite Core Automation for AWS, Azure and IBM Cloud using the automation built from a Bill Of Materials (BOM).

The automation modules installs the latest versions of the following:

- MAS Core
- Mongo Community
- IBM Suite License Service
- IBM Behavior Analytics Service
- IBM Cert Manager


## Quick Start

BOMs are the raw ingredients for building automation for complex cloud installations. They are described in `YAML` and  enables automation to be created to deploy infrastructure and software into cloud environments.


GitOps within an AWS ROSA, Azure ARO, IBM Cloud ROKS cluster.

## Standard / Advanced

List of BOMs for Maximo, there is a generic one for full customization. The others have specific setting to enable install into the cloud platform with default storage classes for that platform.  Note that customization is still possible even after the automation is generated.
