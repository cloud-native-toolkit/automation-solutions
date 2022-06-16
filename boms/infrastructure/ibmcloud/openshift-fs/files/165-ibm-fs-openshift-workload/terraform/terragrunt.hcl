dependencies {
  paths = ["../150-ibm-fs-workload-vpc-openshift"]
}

before_hook "vpn" {
  commands     = ["apply", "plan", "destroy"]
  execute      = ["${get_parent_terragrunt_dir()}/start-vpn.sh"]
}
