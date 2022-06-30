include "root" {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../105-ibm-vpc-openshift", "../200-ibm-openshift-gitops"]
}
