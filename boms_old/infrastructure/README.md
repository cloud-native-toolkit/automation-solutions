# Infrastructure Bills of Material

The infrastructure BOMs are provided in three reference architectures:

1. QuickStart

    Intended for use in demo environments, this reference architecture provides a simple Red Hat OpenShift environment with a small footprint and minimal security constraints.

2. Standard

    Intended for use in POC and typical development environments, this reference architecture provides a secure Red Hat OpenShift environment with private networking and enhanced data encryption in a single VPC network.

3. Advanced

    Intended for more sophisticated production environments, this reference architecture provides a secure Red Hat OpenShfit environment with private networking and enhanced data encryption in a layered and isolated VPC network.

The generic definition of each of these reference architectures and the detailed implementation of each are provided in the [architectures](../../architectures) folder.

These same three reference architectures are provided for each of the hyperscalers. Currently, BOMs are defined for:

- [AWS](aws)
- [Azure](azure)
- [IBM Cloud](ibmcloud)

### Loading Files into Ascent

To auto load all the BOMs into the Ascent tool run the following command

```bash
./load-ascent.sh <ASCENT_API_TOKEN> <URL TO API>
```

This will auto ingest the Infrastructure Bill of Materials into the Ascent Tool
