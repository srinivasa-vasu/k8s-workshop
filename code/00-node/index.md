<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">

---
pageTitle: Create a Node label


<md-icon class="fa fa-clock-o fa-2x" aria-hidden="true"></md-icon> Time to complete 15ms

# Node labels

A node is a worker machine in Kubernetes. Each node contains the services necessary to run pods and is managed by the master components. The services on a node include the container runtime, kubelet, kube-proxy etc,.

discussionPoints:
In this exercise, we shall look at setting labels to a K8s node. It can be done in multiple ways. We shall look at the following options,

  - <i class="fa-li fa fa-check-square"></i> kubecl cli

  - <i class="fa-li fa fa-check-square"></i> K8s manifest

  - <i class="fa-li fa fa-square"></i> API

## Add labels

**List the nodes in your cluster.**

``` go-cli
kubectl get nodes -o wide
```

<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
You will get an output similar to this based on the cluster size,

    NAME       STATUS    ROLES     AGE       VERSION
    vm-1234    Ready     <none>    35h       v1.12.4
    vm-4567    Ready     <none>    35h       v1.12.4

**Choose one of the nodes and add a label to it.**

``` kubectl
kubectl label nodes vm-1234 role=schedule
```

<i class="fa fa-hand-o-right fa-2x" aria-hidden="true"></i> Same can be done by running `sh 00-Node/_1.apply.sh`
 Show `sh 00-Node/_1.apply.sh`
{{codebase-file codebase="k8s-workshop" path="units/k8s-waves/node/_1.apply.sh" lang="bash" ref="master" hidden="true"}}

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/00-Node/_1.apply.sh>

**Verify that your chosen node as role=schedule label applied.**

    kubectl get nodes --show-labels

> **Note**
> 
> The output will be similar to this

    NAME       STATUS    ROLES     AGE       VERSION   LABELS
    vm-1234    Ready     <none>    36h       v1.12.4   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=minikube,role=schedule

## Clean-up

\[✔\] sh 00-Node/\_1.clean.sh

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/00-Node/_1.clean.sh>
