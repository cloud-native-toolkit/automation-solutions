dependencies {
  paths = ["../130-ibm-fs-management-vpc-openshift"]
}

before_hook "vpn" {
  commands     = ["apply", "plan", "destroy"]
  execute      = ["${get_parent_terragrunt_dir()}/start-vpn.sh"]
}
