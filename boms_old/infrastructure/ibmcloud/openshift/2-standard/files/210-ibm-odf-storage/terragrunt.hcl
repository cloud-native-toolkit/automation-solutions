include "root" {
  path = find_in_parent_folders()
}

locals {
  dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

  dep_115 = local.dependencies.names_115
  mock_115 = local.dependencies.mock_115
  cluster_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_115}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_115}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_115}"

  dep_200 = local.dependencies.names_200
  mock_200 = local.dependencies.mock_200
  gitops_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_200}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_200}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_200}"
  gitops_skip_outputs = fileexists("${get_parent_terragrunt_dir()}/${local.dep_200}/terragrunt.hcl") ? false : true
}

dependency "openshift" {
    config_path = local.cluster_config_path
    skip_outputs = true
}

dependency "gitops" {
    config_path = local.gitops_config_path
    skip_outputs = local.gitops_skip_outputs

    mock_outputs_allowed_terraform_commands = ["validate", "init", "plan", "destroy", "output"]
    mock_outputs = {
        gitops_host = "fake_gitops_host"
        gitops_org = "fake_gitops_orf"
        gitops_name = "fake_gitops_name"
        gitops_project = "fake_gitops_project"
        gitops_username = "fake_gitops_username"
        gitops_token = "fake_gitops_token"
    }
}

inputs = {
  gitops_repo_host = dependency.gitops.outputs.gitops_host
  gitops_repo_org = dependency.gitops.outputs.gitops_org
  gitops_repo_repo = dependency.gitops.outputs.gitops_name
  gitops_repo_project = dependency.gitops.outputs.gitops_project
  gitops_repo_username = dependency.gitops.outputs.gitops_username
  gitops_repo_token = dependency.gitops.outputs.gitops_token
}

