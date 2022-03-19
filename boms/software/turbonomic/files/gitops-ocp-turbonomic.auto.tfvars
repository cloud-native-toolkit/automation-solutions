## gitops-ocp-turbonomic_storage_class_name: Name of the block storage class to use - if multizone deployment then waitforfirstconsumer must be set on storageclass binding mode
gitops-ocp-turbonomic_storage_class_name="<your block storage on aws: gp2, on azure: managed-premium>"

## gitops-repo_host: The host for the git repository.
gitops-repo_host="github.com"

## gitops-repo_type: The type of the hosted git repository (github or gitlab).
gitops-repo_type="github"

## gitops-repo_org: The org/group where the git repository exists/will be provisioned.
gitops-repo_org="<your gitorg - most likely your username>"

## gitops-repo_repo: The short name of the repository (i.e. the part after the org/group name)
gitops-repo_repo="<repo name to create for git ops configuration>"

## gitops-repo_username: The username of the user with access to the repository
gitops-repo_username="<your git username>"

## gitops-repo_token: The personal access token used to access the repository
gitops-repo_token="<your git token with permission to create repos>"

## server_url: The url for the OpenShift api
server_url="<openshift target server url>"

## cluster_login_token: Token used for authentication
cluster_login_token="<openshift targer server token>"

