# automation-solutions

A collection of Bills of Materials (BOMs) that address solution/use-case scenarios.

A Solution is a descriptor that contains metadata and the list of BOMs that will be used to generate terraform for a specific Solution or Use Case.

Repo contents:
- `boms` directory contains a collection of bills of materials, and their corresponding files (subdir)
- `common-files` directory that contains common files that will be included when we generate a solution
- `schema` - sample schema/CRD structure for a solution
- `solutions` - Solution instances

## Bill of Materials YAML reference

Here's the schema of how a bill of materals `bom.yaml` should be constructed:

- `apiVersion`: `cloud.ibm.com/v1alpha1`
- `kind`: `BillOfMaterial`
- `metadata`: BOM metadatas
- `metadata.name`: Unique BOM identifier, e.g. `110-vpc-openshift`
- `metadata.labels`: BOM labels
- `metadata.labels.type`: BOM type, one of: `infrastructure|software`
- `metadata.labels.platform`: Cloud Platform if BOM is platform specific, one of: `ibm|azure|aws`
- `metadata.labels.code`: BOM 3 digits unique BOM code
- `metadata.annotations`: BOM anotations
- `metadata.annotations.displayName`: BOM plain text name
- `metadata.annotations.description`: BOM description
- `spec`: BOM specifications
- `spec.modules`: **List** of modules referenced by this BOM
- `spec.modules.name`: Module name
- `spec.modules.alias`: Module alias (to be used to reference this module within the BOM)
- `spec.modules.variables`: **List** of module variables to set for this BOM
- `spec.modules.variables.name`: Variable name
- `spec.modules.dependencies`: **List** of module dependencies
- `spec.modules.dependencies.name`: Module name
- `spec.modules.dependencies.ref`: Module reference (alias) if dependent modules appears more than once in the BOM (or generated terraform)

### Examples

### Infrastructure

Example of a valid Infrastructure BOM:

```yaml
apiVersion: cloud.ibm.com/v1alpha1
kind: BillOfMaterial
metadata:
  name: 110-vpc-openshift
  labels:
    type: infrastructure
    platform: aws
    code: 110
  annotations:
    displayName: AWS VPC OpenShift
    description: AWS VPC and Red Hat OpenShift servers
spec:
  modules:
    - name: aws-vpc
    - name: aws-vpc-subnets
    - name: aws-rosa
```

#### Software

Example of a valid Sofware BOM:

```yaml
apiVersion: cloud.ibm.com/v1alpha1
kind: BillOfMaterial
metadata:
  name: 406-gitops-ocp-turbonomic-ibmcloud
  labels:
    type: software
    platform: ibm
    code: '406'
  annotations:
    displayName: Turbonomic on OpenShift - IBM Cloud
    description: GitOps deployment of Turbonomic on IBM Cloud
spec:
  modules:
    # Login to existing OpenShift cluster
    - name: ocp-login

    # Create the GitOps Repo
    - name: gitops-repo

    # Install OpenShift GitOps and Bootstrap GitOps (aka. ArgoCD)
    - name: argocd-bootstrap
      variables:
        - name: create_webhook
          value: true

    # Create Name Space for Turbonomic
    - name: gitops-namespace
      variables:
        - name: name
          value: turbonomic

    # Define storage class for Turbonomic on IBM Cloud
    - name: gitops-storageclass
      alias: storage
      variables:
        - name: name
          value: ibmc-vpc-block-mzr
        - name: provisioner_name
          value: vpc.block.csi.ibm.io
        - name: parameter_list
          value: [{key : "classVersion",value : "1"},{key : "csi.storage.k8s.io/fstype", value : "ext4"}, {key : "encrypted",value : "false"},{key : "profile",value : "10iops-tier"},{key : "sizeRange",value : "[10-2000]GiB]"}]

    - name: gitops-ocp-turbonomic
      dependencies:
        - name: storage_class_name
          ref: storage
```