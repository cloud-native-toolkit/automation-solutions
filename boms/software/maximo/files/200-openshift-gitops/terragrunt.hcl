include "root" {
  path = find_in_parent_folders()
}

locals {
  dependencies = yamldecode("${get_parent_terragrunt_dir()}/layers.yaml")
  dep_105 = local.dependencies.name_105
  mock_105 = local.dependencies.mock_105
}

dependency "cluster" {
  config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_105}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_105}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_105}"
  skip_outputs = fileexists("${get_parent_terragrunt_dir()}/${local.dep_105}/terragrunt.hcl") ? false : true

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
  mock_outputs = {
    cluster_server_url = ""
    cluster_username = ""
    cluster_password = ""
    cluster_token = ""
  }
}

inputs = {
  server_url             = dependency.cluster.outputs.cluster_server_url
  cluster_login_username = dependency.cluster.outputs.cluster_username
  cluster_login_password = dependency.cluster.outputs.cluster_password
  cluster_login_token    = dependency.cluster.outputs.cluster_token
}
