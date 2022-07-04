skip = true

terraform {
  extra_arguments "reduced_parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=6"]
  }

  before_hook "auto_tfvars" {
    commands = ["plan", "apply"]
    execute = ["${get_parent_terragrunt_dir()}/copy-auto-tfvars.sh", "${get_parent_terragrunt_dir()}", "."]
  }

  after_hook "auto_tfvars" {
    commands = ["apply"]
    execute = ["${get_parent_terragrunt_dir()}/copy-auto-tfvars.sh", ".", "${get_parent_terragrunt_dir()}"]
  }
}
