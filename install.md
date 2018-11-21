# Install

The MetacenterIO agent can be quickly deployed into any Kubernetes cluster running v1.8+.

If you don't already have an account, head over to [Account Signup](https://console.metacenter.io/login#signup)


Metacenter relies on agents installed in your Kubernetes cluster to gather data for Metacenter to process.
One agent per Kubernetes cluster is necessary.
The agent runs as a Kubernetes Cronjob, executed every 15 minutes by default. 
Clusters running 100k+ pods/app instances may require upwards of 5 minutes processing time.

**resource requirements** are minimal. 120MB of memory.

## Download
Its easy to get started with Metacenter. 

First create a Service Account:

Look for the settings icon (<span class="fa fa-cog"></span>) in the lower left-hand corner of the screen. 

<img src="_media/mainpage.png" width="400">

Click (<span class="fa fa-plus"></span>) to add a new Service Account.

Then download the configuration (<span class="fa fa-cloud-download"></span>)

<img src="_media/service_account_widget.png" width="400">

For more information go to [Service Accounts](serviceaccount.md)

## Configure
## Deploy