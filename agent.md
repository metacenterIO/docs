> Agent

The Agent supplies Metacenter with metadata from each Kubernetes cluster.

To get started quickly, checkout the [Install Guide](install.md)

For detailed information about the agent, keep reading.

## Runtime
The agent runs as a [Kubernetes Cronjob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/). By default this job executes every 15 minutes.
One agent per Kubernetes cluster is required.

## Configuration
Agents are configured through environment variables, typically specified through a Kubernetes config file.



### Options:

`CLUSTER_NAME (required)` - The name of the Kubernetes cluster the agent is running in.
Agent will attempt to derive this information itself. It will fall back to `CLUSTER_NAME`.
It can be any string without special characters.

`REGION_CODE (required)` - Some cloud providers apply pricing based on the regional location in which instances are running.
For this reason, its important to supply the correct `REGION_CODE`. 
Example: `us-east-1`

`META_SERVICE (required)` - Service account id. If downloaded from Metacenter, this will be prepopulated.

`META_PASSWORD (required)` - While the agent uses JWT (JSON Web Tokens) for authentication, initial authentication is required.
This is also prepopulated when downloading config from Metacenter.

`ITERATE_TIME (optional)` - `default: 300` How often the cronjob will run in seconds. 

`CLOUD_PROVIDER (optional)` - `default: aws` Currently only `aws` is available. 

`INSTANCE_TYPE (optional)` - `default: c4.xlarge` Default server size. Only used as last resort. 

`DEFAULT_CPU (optional)` - `default: 1` Default app CPU size. Only used as last resort. 

`DEFAULT_MEMORY (optional)` - `default: 2Gi` Default app Memory size. Only used as last resort. 

`RESPONSE_LIMIT (optional)` - `default: 100`. Agent will query the Kubernetes API for events. 
This option limits the number of events retrieved at one time.
For Clusters with high pod churn the limit may be increased for the agent to keep up.



### AWS specific:
`INSTANCE_TENANCY (required)` - AWS has two tenancy options. `Shared` or `OnDemand`. 
Cost for running EC2 instances vary considerably based on this setting. Please ensure this is set correctly.
Majority of customers run `Shared`.

`RESERVED_OR_ONDEMAND (required)` - AWS also prices instances based on `Reserved` or `OnDemand`.
This option will effect the accuracy of Metacenter cost analysis.


## Example Configuration Values


```
...
- name: CLUSTER_NAME          # K8s Cluster Name, used if not detected
  value: "%%CLUSTER_NAME%%"     # Ex metacenter-cluster
- name: REGION_CODE           # region code for Cloud Provider
  value: "%%REGION_CODE%%"      # Ex us-east-1
- name: INSTANCE_TENANCY      # For AWS, Shared or Dedicated
  value: "Shared"
- name: RESERVED_OR_ONDEMAND  # For AWS, Reserved or OnDemand
  value: "OnDemand"
- name: META_SERVICE          # Metacenter Service name
  value: "%%SERVICE_ACCOUNT_ID%%"
- name: META_PASSWORD         # Metacenter Service password
  value: "%%SERVICE_ACCOUNT_ID%%"
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
