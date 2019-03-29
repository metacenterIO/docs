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


cronjob.yaml

```
---
apiVersion: v1
kind: Namespace
metadata:
  name: metacenter-agent
---
apiVersion: v1
data:
  .dockerconfigjson: eyJhdXRocyI6eyJodHRwczovL2luZGV4LmRvY2tlci5pby92MS8iOnsidXNlcm5hbWUiOiJtY3JlZ2NyZWQiLCJwYXNzd29yZCI6ImhNZU4yR0ZCVXhQUm5xYkQiLCJlbWFpbCI6Im1jcmVnY3JlZEBtZXRhY2VudGVyLmlvIiwiYXV0aCI6ImJXTnlaV2RqY21Wa09taE5aVTR5UjBaQ1ZYaFFVbTV4WWtRPSJ9fX0=
kind: Secret
metadata:
  name: mcregcred
  namespace: metacenter-agent
type: kubernetes.io/dockerconfigjson
---
apiVersion: v1
kind: ServiceAccount
metadata:
  namespace: metacenter-agent
  name: metacenter
imagePullSecrets:
- name: mcregcred
---
apiVersion: v1
kind: Secret
metadata:
  name: mcsecret
  namespace: metacenter-agent
type: Opaque
stringData:
  META_SERVICE: %%SERVICE_ACCOUNT_ID%%
  META_PASSWORD: %%SERVICE_ACCOUNT_PASSWORD%%
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: metacenter-cluster-role
rules:
- apiGroups:
  - apiextensions.k8s.io
  resources:
  - customresourcedefinitions
  verbs:
  - '*'
- apiGroups:
  - alpha.metacenter.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - metrics.k8s.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - services
  - endpoints
  verbs:
  - get
  - create
  - update
- apiGroups:
  - ""
  resources:
  - nodes
  verbs:
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - namespaces
  verbs:
  - list
  - watch
  - get
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: metacenter
subjects:
- kind: ServiceAccount
  name: metacenter
  namespace: metacenter-agent
  apiGroup: ""
roleRef:
  kind: ClusterRole
  name: metacenter-cluster-role
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: metacenter-agent
  namespace: metacenter-agent
spec:
  schedule: "0 * * * *"
  concurrencyPolicy: Replace
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: metacenter-agent
            image: metacenterio/agent:0.4.22-beta
            env:
            - name: CLUSTER_NAME          # K8s Cluster Name, used if not detected
              value: %%CLUSTER_NAME%%
            - name: REGION_CODE           # Region Code for Cloud Provider
              value: %%REGION%%
            - name: META_SERVICE
              valueFrom:
                secretKeyRef:
                  name: mcsecret
                  key: META_SERVICE
            - name: META_PASSWOR
              valueFrom:
                secretKeyRef:
                  name: mcsecret
                  key: META_PASSWORD
            - name: ROOT_PATH
              value: '.'
          imagePullSecrets:
          - name: mcregcred
          serviceAccountName: metacenter
          restartPolicy: OnFailure
```
