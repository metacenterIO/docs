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

`CLUSTER_NAME` - The name of the Kubernetes cluster the agent is running in.
Agent will attempt to derive this information itself. It will fall back to `CLUSTER_NAME`.
It can be any string without special characters.

`REGION_CODE` - Some cloud providers apply pricing based on the regional location in which instances are running.
For this reason, its important to supply the correct `REGION_CODE`. 
Example: `us-east-1`

`META_SERVICE` - Service account id. If downloaded from Metacenter, this will be prepopulated.

`META_PASSWORD` - While the agent uses JWT (JSON Web Tokens) for authentication, initial authentication is required.
This is also prepopulated when downloading config from Metacenter.

`ITERATE_TIME` - How often the Cronjob will run in seconds.

`CLOUD_PROVIDER` - Currently only `aws` is available.

`INSTANCE_TYPE` - Default server size. Only used as last resort.

`DEFAULT_CPU` - Default app CPU size. Only used as last resort.

`DEFAULT_MEMORY` - Default app Memory size. Only used as last resort.

`RESPONSE_LIMIT` - Default is `100`. Agent will query the Kubernetes API for events. 
This option limits the number of events retrieved at one time.
For Clusters with high pod churn the limit may be increased for the agent to keep up.



### AWS specific:
`INSTANCE_TENANCY` - AWS has two tenancy options. `Shared` or `OnDemand`. 
Cost for running EC2 vary based on this setting. Please ensure this is set correctly.
Majority of customers run `Shared`.

`RESERVED_OR_ONDEMAND` - AWS also prices instances based on `Reserved` or `OnDemand`.
This option will effect the accuracy of Metacenter cost analysis.

