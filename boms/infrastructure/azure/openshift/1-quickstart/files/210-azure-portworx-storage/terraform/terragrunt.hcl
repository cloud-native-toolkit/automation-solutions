dependencies {
    paths = ["../105-azure-ocp-ipi"]
}

dependency "ocp-ipi" {
    config_path = "../105-azure-ocp-ipi"

    mock_outputs_allowed_terraform_commands = ["validate"]
    mock_outputs = {
        bin_dir = "fake-bin-dir"
        config_file_path = "fake/config/file/path"
        resource_group_name = "fake-rg"
    }
}

inputs = {
    resource_group_name = dependency.ocp-ipi.outputs.resource_group_name
    config_file_path = dependency.ocp-ipi.outputs.config_file_path
    bin_dir = dependency.ocp-ipi.outputs.bin_dir
}