# Automation runtime environments

## Supported runtimes

There are two supported runtimes where the automation is expected to be executed inside of:

1. [Docker Desktop](#docker-desktop) (Container engine)
2. [Multipass](#multipass) (VM)

The Terraform automation can be run from the local operating system, but it is recommended to use either of the runtimes listed above, which provide a consistent and controlled environment, with all dependencies preinstalled.


### Docker Desktop

[Docker Desktop](https://docs.docker.com/desktop/) is an easy-to-use application that enables you to build and share containerized applications.

It provides a simple interface that enables you to manage your containers, applications, and images directly from your machine without having to use the CLI to perform core actions.

Docker Desktop is supported across Mac, Windows, and Linux, and can be downloaded and installed directly from: https://www.docker.com/products/docker-desktop/

Once installed, use the automation template's `launch.sh` script to launch an interactive shell where the Terraform automation can be executed.

### Multipass

[Multipass](https://multipass.run/) is a simplified Ubuntu Linux Virtual Machine that you can spin up with a single command.   With this option you spin up a virtual machine with a predifined configuration that is ready to run the Terraform automation.  

You can download and install Multipass from https://multipass.run/install

Once you have installed Multipass, open up a command line terminal and `cd` into the *parent* directory where you cloned the automation repo.

Download the [cloud-init](https://github.com/cloud-native-toolkit/sre-utilities/blob/main/cloud-init/cli-tools.yaml) script for use by the virtual machine using: 

```
curl https://raw.githubusercontent.com/cloud-native-toolkit/sre-utilities/main/cloud-init/cli-tools.yaml --output cli-tools.yaml
```

The `cli-tools` cloud init script prepares a VM with the same tools available in the quay.io/cloudnativetoolkit/cli-tools-ibmcloud container image. Particularly:

- `terraform`
- `terragrunt`
- `git`
- `jq`
- `yq`
- `oc`
- `kubectl`
- `helm`
- `ibmcloud cli`

Launch the Multipass virtual machine using the following command:

```
multipass launch --name cli-tools --cloud-init ./cli-tools.yaml
```

This will take several minutes to start the virtual machine and apply the configuration.  

Once the virtual machine is started, mount the local file system for use within the virtual machine using the following command:

```
multipass mount $PWD cli-tools:/automation
```

This will mount the parent directory to the `/automation` directory inside of the virtual machine.

Once the virtual machine has started, run the following command to enter an interactive shell:

```
multipass shell cli-tools
```

Once in the shell, `cd` into the `/automation/{template}` folder, where source  `{template}` is the Terraform template you configured.  Then you need to load credentials into environment variables using the following command: 

```
source credentials.properties
```

Once complete, you will be in an interactive shell that is preconfigured with all dependencies necessary to execute the Terraform automation.



----


## Unsupported runtimes.

Additional container engines, such as podman or colima may be used at your own risk.  They may work, however, there are known issues using these environments,  and the development team does not provide support for these environments.

Known issues include:
 1. Network/DNS failures under load
 2. Read/write permissions to local storage volumes

### Colima instructions

- Install [Brew](https://brew.sh/)
- Install [Colima](https://github.com/abiosoft/colima) (a replacement for Docker Desktop ) and the **docker** cli
   ```shell
   brew install colima docker
   ```
- More information available at: https://github.com/abiosoft/colima#installation

### Podman instructions

- Install [Brew](https://brew.sh/)
- Install [Podman](https://podman.io) (a replacement for Docker Desktop ) and the **docker** cli
   ```shell
   brew install podman docker
   ```
- More information available at: https://podman.io/getting-started/installation