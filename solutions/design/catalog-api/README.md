# Catalog API spec

The information in the module catalog will support three different access styles. The choice of which one to use will be determined by the particular use case.

## Simple YAML file

For simple catalogs that are hosted on a web server without a server-side backend, a hosted YAML (or JSON) file can be provided for the catalog. Or course, the drawback to this approach is no filtering is available for the catalog and the entire file will be downloaded. In most cases, this is not an issue. 

## REST service(s)

### `/module`

#### Filters

### `/bom`

#### Filters

## Graph API

### `/graphapi`

```
query {
  modules {
  }
  boms {
  }
}
```

#### Filters

