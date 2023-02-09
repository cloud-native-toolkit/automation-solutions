# Catalog API spec

The information in the module catalog will support three different access styles. The choice of which one to use will be determined by the particular use case.

## Simple YAML file

For simple catalogs that are hosted on a web server without a server-side backend, a hosted YAML (or JSON) file can be provided for the catalog. Or course, the drawback to this approach is no filtering is available for the catalog and the entire file will be downloaded. In most cases, this is not an issue. 

## REST service(s)

### List BOMs

`GET /boms`

#### Query parameters

- `start` - The starting position in the list for the return set (used for pagination). Defaults to `0` if not provided.
- `count` - The number of results to return (used for pagination). Defaults to `20` if not provided. A value of `-1` returns all results.
- `format` - The format that should be returned.
- `filters` - The optional values used to filter the results. See [Filter syntax](#filter-syntax) for details

#### Query result

- `start` - The value used for the starting position
- `count` - The number of values returned
- `hasMore` - Flag indicating more results are available
- `next` - Query string used to retrieve next results (if any)
- `results` - List of BillOfMaterialEntry types

#### Schema

##### BillOfMaterialEntry

- `name` - the name/id of the bill of material
- `displayName` - the human-friendly name of the bill of material
- `description` - the description of the purpose and structure of the bill of material
- `type` - the type of the bill of material (bom or solution)
- `category` - the category of the bill of material (e.g. infrastructure, gitops, software)
- `sub-category` - the sub-category of the bill of material (e.g. integration, data, ai)
- `tags` - the list of tags used to further categorize the bill of material
- `cloudProvider` - the cloud provider where the infrastructure is provisioned (if applicable)
- `iconUrl` - the url to the icon used to represent the bom
- `versions` - the list of available versions for the bill of material of type BillOfMaterialVersionRef

##### BillOfMaterialVersionRef

- `version` - the version number
- `metadataUrl` - the url to the metadata file containing the details of the bill of material

### Get bom by name/id

Retrieves the list of BOM versions with links to metadata url

`GET /boms/:name`

### Get bom versions

Retrieves the versions and metadata urls for a bom

`GET /boms/:name/versions`

### Get bom version

Retrieves the detailed metadata for a particular BOM version

`GET /boms/:name/versions/:version`

### List modules

`GET /modules`

#### Query parameters

### Get module

`GET /module/:name`

### Get module versions

Retrieves the versions and metadata urls for a bom

`GET /modules/:name/versions`

### Get bom version

Retrieves the detailed metadata for a particular module version

`GET /modules/:name/versions/:version`

## Graph API

### `/graphapi`

```
query BomQuery($filters: String!) {
  boms(filters: $filters) {
    name
    displayName
    description
    cloudProvider
    category
    subCategory
    tags
    type
    versions {
      metadataUrl
      version
    }
  }
}
```

```
query GetBomQuery(name: String!) {
  bom(name: $name) {
    name
    displayName
    description
    cloudProvider
    category
    subCategory
    tags
    type
    versions {
      metadataUrl
      version
    }
  }
}
```

```
query ModuleQuery(filters: String!) {
  modules(filters: $filters) {
    id
    name
    displayName
    description
    interfaces
    category
    platforms
    tags
    cloudProvider
    versions {
      version
    }
  }
}
```

```
query GetModuleQuery(name: String!) {
  module(name: $name) {
    id
    name
    displayName
    description
    interfaces
    category
    platforms
    tags
    cloudProvider
    versions {
      version
    }
  }
}
```

#### Filters

## Filter syntax

The filter is defined a single string. Each filter element is made up of a key, an operator, and a matching value and 
each element is separated by a semi-colon. For example:

```
/boms?filters=cloudProvider=ibm;tags in [standard];name contains vpc;
```

Within each filter segment a number of operators are allowed.

### Operators

- `=`, `<>`, `>=`, `<`, `<=` - standard equals, not-equals, greater than, etc comparison
- `contains` - string contains value OR list contains value
- `like` - regular expression
- `in` - matches one of multiple values in a list