# IBM Cloud Reference Architecture Bills of Material

This folder contains the Bills of Material (BOMs) for the Azure Reference Architectures. It is provided in three different flavors:

- QuickStart
- Standard
- Advanced

## Overview

BOMs are the raw ingredients for building automation for complex cloud installations. They are described in `YAML` and enable automation to be created to deploy infrastructure and software into cloud environments.

## Bills of Material

The automation is defined as multiple BOMs that provide layers of provisioned infrastructure and software. Each flavor of reference architecture utilizes different BOMs to provide the required infrastructure. The listing of BOMs for each flavor is provided in the table below:

<table>
<thead>
<tr>
<th>Layers</th>
<th>Quick Start</th>
<th>Standard</th>
<th>Advanced</th>
</tr>
</thead>
<tbody>
<tr>
<th>0xx - Setup</th>
<td>N/A</td>
<td><ul><li>000 - Account Setup</li></ul></td>
</tr>
<tr>
<th>1xx - Infrastructure</th>
<td><ul><li><a href="1-quickstart/110-azure-ocp-ipi.yaml">110 - Azure OpenShift IPI</a></li></ul></td>
<td>
<ul>
<li>100 - Shared Services</li>
<li>110 - VPC OpenShift</li>
</ul>
</td>
<td>
<ul>
<li>100 - Shared Services</li>
<li>110 - Edge VPC</li>
<li>130 - Development VPC OpenShift</li>
<li>150 - Production VPC OpenShift</li>
</ul>
</td>
</tr>
<tr>
<th>2xx - OpenShift configuration</th>
<td>
<ul>
<li><a href="1-quickstart/205-portworx-storage.yaml">205 - Portworx Storage</a></li>
</ul>
</td>
<td>
<ul>
<li>205 - Portworx Storage</li>
</ul>
</td>
<td>
<ul>
<li>205 - Portworx Storage</li>
</ul>
</td>
</tr>
</tbody>
</table>

### Validated Open-Source Release

Before you attempt to generate and modify the BOM content for your solution, we recommend that you deploy the reference architecture as-provided to get a feel for it. We have provided a released and validated version of the [IBM Cloud OpenShift Reference Architectures](https://github.com/IBM/automation-ibmcloud-infra-openshift) in an open-source repository. Follow the instructions in that repo to provision the infrastructure with the automation.

If you want to download the latest version from the *Solution Builder*, use the [Ascent](https://ascent.openfn.co) tool and log in with your IBM ID. Navigate to the Solution view and click *Download* on the *IBM Cloud Reference Architecture* tile.

## Generating Automation

If you want to use the latest upstream content you can generate the automation using the steps below:

### Install IasCable

First you will need to install the latest version of [iascable](https://github.com/cloud-native-toolkit/iascable) into your `/usr/local/bin` folder, you can do this by running the following cli command. This tools converts BOMs into automation.

```shell
curl -sL https://raw.githubusercontent.com/cloud-native-toolkit/iascable/main/install.sh | sh
```

### Generate all the layers

A script (`generate.sh`) has been provided to generate the terraform for all the flavors and all the layers at one time. The script only requires one argument - the directory where the generated automation.

To run the script, run the following:

```shell
boms/infrastructure/ibmcloud/openshift/generate.sh ~/automation
```

### Process individual BOMs

1. Clone this repository onto your machine or trusted environment.
2. Select the BOM that you will use, e.g. `boms/infrastructure/ibmcloud/openshift/1-quickstart/110-vpc-openshift.yaml`
3. Run the `iascable build` command to generate the output

```shell
iascable build -i boms/infrastructure/ibmcloud/openshift/1-quickstart/110-vpc-openshift.yaml -o ~/automation
```

### How to run the generated automation

To start, read the instructions for configuring your automation from this [README.md](files/README.md). Then navigate to your output directory and follow those instructions.
