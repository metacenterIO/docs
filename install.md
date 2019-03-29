If you don't already have an account, head over to [Account Signup](https://metacenter.io/login#signup)


> Install

The MetacenterIO agent can be quickly deployed into any Kubernetes cluster running v1.8+.


Metacenter relies on an agent installed in your Kubernetes cluster.
The agent runs as a Kubernetes Cronjob, executed every 15 minutes by default. 


## Requirements
**[Metrics Server](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/metrics-server)** - Generally metrics server comes by default in any cluster running version 1.8+.

**Minimum Resource Requirements**
    - 250MB Memory
    - 500m CPU
    
?> By default, the agent is deployed as BestEffort, giving it the lowest priority in Kubernetes for resource consumption. If left with the default configuration, you may find the agent utilizing more resource than listed because it was available during execution.

## Download

First create a Service Account:

Look for the settings icon (<span class="fa fa-cog"></span>) in the lower left-hand corner of the screen. 

<img src="_media/mainpage.png" width="400">

Once on the Settings Page, Click (<span class="fa fa-plus"></span>) next to Service Account.

A "New Service Account" window will appear with Account details.

Both `RBAC` and `no RBAC` configs are provided. 

<img src="_media/add_service_account.png" width="600">

More information about [Service Accounts](serviceaccount.md)



## Deploy


```
kubectl create -f mc_cronjob.yaml; kubectl create job --from=cronjob/metacenter-agent mc-first-run -n metacenter-agent

```