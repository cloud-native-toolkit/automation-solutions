
# Manual Deployment Steps

These steps are used as an alternative to the `apply-all.sh` script, which will automatically process all layers of this solution.  These steps should be run in lieu of the [Automated Deployment](RUNTIMES.md#automated-deployment) step.

1. First navigate into the `200-openshift-gitops` folder and run the following commands

    ```
    cd 200-openshift-gitops
    terraform init
    terraform apply --auto-approve
    ```


2. This will kick off the automation for setting up the GitOps Operator into your cluster.  Once complete, you should see message similar to:

    ```
    Apply complete! Resources: 78 added, 0 changed, 0 destroyed.
    ```

3. You can check the progress by looking at two places, first look in your github repository. You will see the git repository has been created based on the name you have provided. The Cloud Pak for Data (CP4D) install will populate this with information to let OpenShift GitOps install the software. The second place is to look at the OpenShift console, Click Workloads->Pods and you will see the GitOps operator being installed.


4. Change directories to the `210-*` folder and run the following commands to deploy storage into your cluster:

    ```
    cd 210-ibm-portworx-storage
    terraform init
    terraform apply --auto-approve
    ```

    > This folder will vary based on the platform and storage options that you selected in earlier steps.

    Storage configuration will run asynchronously in the background inside of the Cluster and should be complete within 10 minutes.

5. Change directories to the `300-cloud-pak-for-data-entitlement` folder and run the following commands to deploy entitlements into your cluster:

    ```
    cd ../300-cloud-pak-for-data-entitlement
    terraform init
    terraform apply --auto-approve
    ```

    > This step **does not** require worker nodes to be restarted as some other installation methods describe.

6. Change directories to the `305-cloud-pak-for-data-foundation` folder and run the following commands to deploy Data Foundation into the cluster.

    ```
    cd ../305-cloud-pak-for-data-foundation
    terraform init
    terraform apply --auto-approve
    ```

    Data Foundation deployment will run asynchronously in the background, and may require up to 45 minutes to complete.

7. You can check the progress of the deployment by opening up Argo CD (OpenShift GitOps).  From the OpenShift user interface, click on the Application menu 3x3 Icon on the header and select **Cluster Argo CD** menu item.)

    This process will take between 30 and 45 minutes to complete.  During the deployment, several cluster projects/namespaces and deployments will be created.

Once complete, go back and complete the [Access the Data Foundation Deployment](RUNTIMES.md#access-the-data-foundation-deployment) instructions.