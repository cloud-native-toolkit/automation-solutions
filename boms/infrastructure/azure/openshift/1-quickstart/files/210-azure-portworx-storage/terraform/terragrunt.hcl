dependencies {
    paths = ["../105-azure-ocp-ipi","../110-azure-acme-certificate"]
}

dependency "acme-certs" {
    config_path = "../110-azure-acme-certificate"

    mock_outputs_allowed_terraform_commands = ["validate","plan"]
    mock_outputs = {
        ca_cert = "fake-ca-cert"
    }
}

dependency "ocp-ipi" {
    config_path = "../105-azure-ocp-ipi"

    mock_outputs_allowed_terraform_commands = ["validate","plan"]
    mock_outputs = {
        server_url = "https://fake.url.org:6443"
        username = "fakeuser"
        password = "fakepassword"
    }    
}

inputs = {
    cluster_ca_cert = dependency.acme-certs.ca_cert
    server_url = dependency.ocp-ipi.server_url
    cluster_login_user = dependency.ocp-ipi.username
    cluster_login_password = dependency.ocp-ipi.password
    azure-portworx_cluster_type = "IPI"
}