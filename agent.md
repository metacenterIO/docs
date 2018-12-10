# Agent

The Agent supplies Metacenter with the data from each Kubernetes cluster.
To get started quickly, checkout the [Install Guide](install.md)

For detailed information about the agent, keep reading.

## Runtime
The agent runs as a Kubernetes Cronjob. By default this job executes every 15 minutes.
An agent per Kubernetes cluster is required.

## Configuration
Agents are configured through environment variables, typically specified through a Kubernetes config file.
Below are the possible config options:

While the only required configs for deploying the agent are `CLUSTER_NAME` and `REGION_CODE`.
In order to ensure accuracy, other options should be considered.


`CLUSTER_NAME` - The name of the Kubernetes cluster the agent is running in.
Agent will attempt to derive this information itself. It will fall back to `CLUSTER_NAME`.
It can be any string without special characters.

`REGION_CODE` - Some cloud providers apply pricing based on the regional location in which instances are running.
For this reason, its important to supply the correct `REGION_CODE`. 
Example: `us-east-1`

`META_SERVICE` - Service account id. If downloaded from Metacenter, this will be prepopulated.

`META_PASSWORD` - While the agent uses JWT (JSON Web Tokens) for authentication, initial authentication is required.
This is also prepopulated when downloading config from Metacenter.

`ITERATE_TIME` - `default: 300` How often the Cronjob will run in seconds. 

`CLOUD_PROVIDER` - `default: aws` Currently only `aws` is available. 

`INSTANCE_TYPE` - `default: c4.xlarge` Default server size. Only used as last resort. 

`DEFAULT_CPU` - `default: 1` Default app CPU size. Only used as last resort. 

`DEFAULT_MEMORY` - `default: 2Gi` Default app Memory size. Only used as last resort. 

`RESPONSE_LIMIT` - `default: 100`. Agent will query the Kubernetes API for events. 
This option limits the number of events retrieved at one time.
For Clusters with high pod churn the limit may be increased for the agent to keep up.



### AWS specific:
`INSTANCE_TENANCY` - AWS has two tenancy options. `Shared` or `OnDemand`. 
Cost for running EC2 instances vary considerably based on this setting. Please ensure this is set correctly.
Majority of customers run `Shared`.

`RESERVED_OR_ONDEMAND` - AWS also prices instances based on `Reserved` or `OnDemand`.
This option will effect the accuracy of Metacenter cost analysis.


## Example Configuration Values


```
...
- name: CLUSTER_NAME          # K8s Cluster Name, used if not detected
  value: '<cluster_name>'
- name: REGION_CODE           # region code for Cloud Provider
  value: "<region_code>"
- name: INSTANCE_TENANCY      # For AWS, Shared or Dedicated
  value: "Shared"
- name: RESERVED_OR_ONDEMAND  # For AWS, Reserved or OnDemand
  value: "OnDemand"
- name: META_SERVICE          # Metacenter Service name
  value: "<service_account_id>"
- name: META_PASSWORD         # Metacenter Service password
  value: '<service_account_password>'
- name: ITERATE_TIME                 # how often to sample the k8s cluster in seconds
  value: "300"
- name: CLOUD_PROVIDER        # Set Cloud Provider (currently aws is supported)
  value: "aws"
- name: INSTANCE_TYPE         # Default instance type, only used if not set on nodes
  value: "c4.xlarge"
- name: DEFAULT_CPU           # Default CPU, used if metrics not available
  value: "1"
- name: DEFAULT_MEMORY        # Default memory, used if metrics not available
  value: "2Gi"
- name: RESPONSE_LIMIT        # Max Number of events to get from K8s API at one time
  value: "200"
...

```
