
terraform {
  before_hook "auto_tfvars" {
    command = ["plan", "apply"]
    execute = ["cp", "${get_parent_terragrunt_dir()}/*.auto.tfvars.json", "."]
  }

  after_hook "auto_tfvars" {
    command = ["apply"]
    execute = ["cp", "./*.auto.tfvars.json", "${get_parent_terragrunt_dir()}"]
  }
}
