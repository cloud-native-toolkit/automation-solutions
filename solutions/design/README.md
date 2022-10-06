# Solution Bill of Materials

## Requirements

1. We need a way to describe how a collection of Bill of Material definitions can be put together into a larger solution. This includes layers that make up the solution and the context of those layers (e.g. infrastructure, platform, software), relationships between Bill of Material definitions (passing variables between layers and sequencing execution), overall inputs and outputs to the solution, and supporting files (scripts, readmes, etc).
2. The solution spec should be clear enough that the definition can be created by hand or with builder tools.
3. The solution spec should have enough information for a tool (iascable) to completely generate the automation without need for external supplementation.
4The solution spec and the automation produced should be clear and understandable by an average user as to what the expected outcome will be when executed. 

## Terminology

**Note:** This terminology is a work in progress and up for feedback.

- **Bill of Materials** - a listing of modules and their relationships that defines a set of automation
- **Solution** - a combination of automation that provides a comprehensive environment to deliver business value, whether POC, Pilot, or Production
- **Layer** - an automation bundle that can be executed either standalone or in combination with other layers. A **Bill of Materials** describes the automation provided in a **Layer** 
- **Stack** - a collection of layers that are executed together to deliver a comprehensive environment. A **Solution BOM** describes a stack that is made up of layers described by **Bill of Materials**

## Specs

### Solution BOM Catalog

The Module Catalog spec will be updated to a new version that encompasses modules and BOMs. Individual catalogs can still contain only modules or only BOMs and be provided together to the `iascable` build tool to create a composite catalog. (Additionally a single BOM metadata or a single module metadata can be provided as input individually without needing to create an entire catalog structure just for one item.)

**v1alpha1** of the catalog spec has `categories` as the root element and within each category has a list of modules within that category. That structure is a relic from a time when the `iascable` tool would guide a user to build a BOM by category. The categories are not used by the `iascable` tool when generating the automation from the catalog.

`v2` of the catalog spec flattens the structure a bit. There are two root attributes in the catalog:

- `modules` - A flat listing of modules. Each module entry has a `category` value that can be used by user interfaces to filter and present modules by category
- `boms` - A flat listing of the Bill of Material and Solution Bill of Material entries. Similar to the modules, each BOM will have a category so the BOMs can be grouped together as well as other metadata for filtering and grouping.

The modules in the catalog will be full module metadata entries. The BOM entries will include the BOM metadata with pointers to the full metadata. (Ideally the full metadata will be stored as assets on versioned Git releases so that a single git repo can support independently versioned releases of multiple BOMs. The use of Git releases will not be a requirement though.)

#### Example

```yaml
apiVersion: cloudnativetoolkit.dev/v2
kind: Catalog
metadata:
  name: default
modules:
  - id: ''
    name: ''
    displayName: ''
    description: ''
    category: ''
    group: ''
    type: '' # terraform or gitops
    cloudProvider: ''
    softwareProvider: ''
    tags: []
    versions: [] # array of version definition objects
boms:
  - id: ''
    name: ''
    displayName: ''
    metadataUrl: '' # Url where the definition of the latest BOM can be found
    tags: [] # (Optional) additional metadata, subcategories, etc
    category: '' # infrastructure, platform, software ?
    type: '' # solution-bom or bom (not sure if this is necessary)
    cloudProvider: '' # (Optional) ibm, aws, azure
    versions:
      - version: ''
        metadataUrl: '' # (Optional) the url to the metadata for this BOM version. If not provided then the url is assumed to be derived from the main metadataUrl
```

### Solution BOM

Like the BillOfMaterial, the Solution BOM structure is modeled after a kubernetes custom resource. This gives the resource a standardized, versioned structure to manage the API definition. (Some day maybe we will have an operator t)

#### ApiVersion and Kind

The apiVersion and kind for the Solution BOM are `cloudnativetoolkit.dev/v1alpha1` and `Solution`. This **kind** distinguishes a `Solution` from a `BillOfMaterial` when processed by **iascable**. 

#### Metadata

The metadata section contains information about the solution. The `name` is required as a unique identifier for the solution itself. The metadata section contains two other sections: **labels** and **annotations**. Both contain key value pairs of string values that add information about the solution. Generally, the labels and annotations are open for any information, but there are some particular values that are understood by the infrastructure. 

##### Labels

**Labels** should contain identifying information that can be used to filter and search for solutions. (In the kubernetes etcd database, labels are added as indexes.) 

- **type** - the type of components provisioned by the Bill of Material (e.g. infrastructure, platform, software, composite) (**Note:** this is called **layer** for the BOMs in the solution. Should we rename it here?)
- **platform** - the cloud provider where the solution will deploy (e.g. ibm, aws, azure)
- **flavor** - the sub-type or flavor of the solution (e.g. quickstart, standard, advanced)

##### Annotations

**Annotations** provide more general documentation about the solution or additional instructions for the generation process.

- **displayName** - the human-friendly name for the solution
- **description** - the short description of the solution
- **files.cloudnativetoolkit.dev/diagram** - the name of the diagram file for the solution. This name should match an entry from the `files` section in the body of the solution
- **files.cloudnativetoolkit.dev/readme** - the name of the README documentation for the solution. This name should match an entry from the `files` section in the body of the solution
- **catalogurl.cloudnativetoolkit.dev/XXX** - a catalog url from which the modules and/or BOMs that make up the solution should be retrieved. The XXX can be any value and any number of these catalogUrl entries can be provided.

#### Spec

There are three major sections to the Solution BOM with a couple of additional fields thrown in as well (e.g. the version)

##### Version

The semantic version string for the solution.

##### Stack

The listing of BOMs that make up the logic of the solution. Any number of BOMs can be listed. At this time, the list of BOMs is static and all BOMs are required (i.e. no optional or alternative BOMs are included like we have for storage options in the Automation Solutions). Each entry in the stack list is a "layer". Each layer entry includes the name of BOM from the catalog, the layer the BOM provides, and the description of the layer.

##### Variables

The listing of variables that require input across the layers. For the most part, these values will be generated when the solution BOM is passed through the iascable tool. However, if there are particular variables that should be highlighted, they can be listed in the source solution BOM.

##### Files

The list of files that should be included in the automation package. The file entry includes the name of the file and the type (doc, script, image, or other). Additionally, the contents of the file can either be provided inline using the `content` attribute or the contents can be referenced via a url with the `contentUrl` value. 
