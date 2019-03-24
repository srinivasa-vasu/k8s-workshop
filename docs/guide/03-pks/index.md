---
pageTitle: PKS - Create your First Cluster
---

<md-icon class="fa fa-clock-o fa-lg" aria-hidden="true"></md-icon> Time to complete 15ms


# First K8s Cluster

## Login to PKS

Run the below command, 

``` go-cli
pks login -a <domain_name> -u <user_name> -k
```

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
_domain_name_ and _user_name_ will be provided by the instructor. Replace the placeholder in the above command with
actual values

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

```
Password: *************
API Endpoint: <redacted>
User: <redacted>

```
<i class="fa fa-exclamation-circle fa-lg" aria-hidden="true" style="color:maroon"></i>
Check with the instructor(s) if you find error/exception with the above command.

## Create K8s Cluster

**Create your first cluster**

``` go-cli
pks create-cluster <cluster_name> --external-hostname <dns_name> -p small -n 1
```

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
_cluster_name_ and _dns_name_ will be provided by the instructor. Replace the placeholder in the above command with
actual values

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

```
Name:                     <redacted>
Plan Name:                small
UUID:                     e032c190-4170-4851-bba4-63d2337424cf
Last Action:              CREATE
Last Action State:        in progress
Last Action Description:  Creating cluster
Kubernetes Master Host:   <redacted>
Kubernetes Master Port:   8443
Worker Nodes:             1
Kubernetes Master IP(s):  In Progress
Network Profile Name:

Use 'pks cluster <redacted>' to monitor the state of your cluster

```

<i class="fa fa-bell fa-lg" aria-hidden="true" style="color:orange"></i>
This process will take sometime to complete. Sit back, relax and enjoy for 15 minutes.

## K8s Cluster Status

**List your cluster status**

``` go-cli
pks list-clusters --json
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

```
[
   {
      "name": "<redacted>",
      "plan_name": "small",
      "last_action": "CREATE",
      "last_action_state": "succeeded",
      "last_action_description": "Instance provisioning completed",
      "uuid": "e032c190-4170-4851-bba4-63d2337424cf",
      "kubernetes_master_ips": [
         "<redacted>"
      ],
      "parameters": {
         "kubernetes_master_host": "<redacted>",
         "kubernetes_master_port": 8443,
         "kubernetes_worker_instances": 1
      }
   }
]
```
<i class="fa fa-exclamation-circle fa-lg" aria-hidden="true" style="color:maroon"></i>
Check with the instructor(s) if _last_action_state is not succeeded_.


## Download Cluster Credentials

Run the below command, 

``` go-cli
pks get-credentials <cluster_name>
```
Get the _cluster_name_ from the previous output. Your cluster credentials would automatically get downloaded to _$HOME/.kube/config_ file. If the above command prompts
for password, use the same pks login password.

