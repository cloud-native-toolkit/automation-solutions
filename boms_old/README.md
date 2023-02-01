# Bill of Material library

A Bill of Material defines the set of infrastructure and/or software components that will be provisioned for a particular reference architecture. Several Bills of Material can be combined to create a larger solution and each Bill of Material can contain as many or as few components as necessary.

For the sake of minimizing the number of combination, we've split the Bills of Material into smaller pieces that can be combined in a number of different ways to produce a solution. We've also created a major separation between infrastructure and software.

**Infrastructure**

In this case, infrastructure is defined as anything that is specific to a cloud provider and is provisioned using APIs provided by the cloud provider, including SaaS offerings. More details on the infrastructure offerings is provided [here](infrastructure)

**Software**

Software encompasses anything that is provisioned in an OpenShift cluster and is therefore independent of specific cloud providers. The only dependency of the software components then is an OpenShift cluster. That OpenShift cluster could have been provisioned using the **Infrastructure** automation components or by any other means. The software components all use a GitOps approach to deploying and managing the software. As a result, the intersection of the infrastructure and software components is the GitOps repository that contains the instructions to deploy the software. More details on the software layers is provided [here](software)

## Bill of Material layers

The Bill of Material components are organized into layers that can be applied in any combination to create a variety of different solutions. The layers follow a numerical taxonomy to help define the structure and sequence of the different layers.

<table>
<thead>
<tr>
<th>Category</th>
<th>Layers</th>
</tr>
</thead>
<tbody>
<tr>
<td>0xx - Environment setup</td>
<td>
<ul>
<li>000 - Account setup</li>
</ul>
</td>
</tr>
<tr>
<td>1xx - Cloud Infrastructure</td>
<td>
<ul>
<li>100 - Shared services</li>
<li>110 - Edge</li>
<li>120 - Development VPC</li>
<li>130 - Development VPC with OpenShift</li>
<li>140 - Production VPC</li>
<li>150 - Production VPC with OpenShift</li>
</ul>
</td>
</tr>
<tr>
<td>2xx - Cluster Infrastructure and Development Tools</td>
<td>
<ul>
<li>200 - OpenShift Gitops bootstrap</li>
<li>210 - Cluster storage</li>
<li>220 - In-cluster development tools</li>
<li>250 - Turbonomic</li>
</ul>
</td>
</tr>
<tr>
<td>3xx - Integration Platform</td>
<td>
<ul>
<li>310 - App Connect Enterprise</li>
<li>315 - App Connect Enterprise Development</li>
<li>320 - MQ</li>
<li>330 - Api Connect</li>
<li>340 - Event Streams</li>
<li>350 - Aptiva</li>
</ul>
</td>
</tr>
<tr>
<td>4xx - Data and AI</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>5xx - Maximo Application Suite</td>
<td>
<ul>
<li>500 - Maximo Core</li>
<li>505 - Maximo Manage</li>
<li>510 - Maximo Monitor</li>
<li>515 - Maximo Health</li>
<li>520 - Maximo Predict</li>
<li>525 - Maximo Visual Inspection</li>
<li>550 - Maximo Health & Predict Utility Industry</li>
<li>...</li>
</ul>
</td>
</tr>
<tr>
<td>6xx - Application Automation</td>
<td>&nbsp;</td>
</tr>
</tbody>
</table>


