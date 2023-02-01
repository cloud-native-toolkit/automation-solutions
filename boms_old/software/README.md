# Software Bills of Material

The software automation is provided in the following folders:

- [Turbonomic](turbonomic) - IBM Turbonomic
- [Integration](integration) - IBM Intergration Platform (APIC, ACE, MQ, EventStreams, etc)
- [Maximo](maximo) - Maximo Application Suite
- [Telco Cloud](telco-cloud) - Telco Industry cloud
- [Dev Tools](devtools) - Cloud-Native Toolkit

### Loading Files into Ascent

To auto load all the BOMs into the Ascent tool run the following command

```bash
./load-ascent.sh <ASCENT_API_TOKEN> <URL TO API>
```

This will auto ingest the Software Bill of Materials into the Ascent Tool


