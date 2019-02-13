---
pageTitle: Create a Node label
---

<md-icon class="fa fa-clock-o fa-lg" aria-hidden="true"></md-icon> Time to complete 15ms


# Node labels

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
A node is a worker machine in Kubernetes. Each node contains the services necessary to run pods and is managed by the master components. The services on a node include the container runtime, kubelet, kube-proxy etc,.

In this exercise, we shall look at setting labels to a K8s node. It can be done in multiple ways. We shall look at the following options,

<ul class="fa-ul">
  <li><i class="fa-li fa fa-square"></i>kubecl cli</li>
  <li><i class="fa-li fa fa-square"></i>K8s manifest</li>
</ul>


## <a name="add_label"></a>Add labels

**List the nodes in your cluster.**

``` go-cli
kubectl get nodes -o wide
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
You will get an output similar to this based on the cluster size,

    NAME       STATUS    ROLES     AGE       VERSION
    vm-1234    Ready     <none>    35h       v1.12.4
    vm-4567    Ready     <none>    35h       v1.12.4

**Choose one of the nodes and add a label to it.**

``` kubectl
kubectl label nodes vm-1234 role=schedule
```

<i class="fa fa-hand-o-right fa-lg" aria-hidden="true"></i> Same can be done by running the script <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `sh 00-node/_1.apply.sh`
{{codebase-file codebase="k8s-workshop" path="code/00-node/_1.apply.sh" lang="bash" ref="master" hidden="true"}}

Source of the K8s Node manifest,

{{codebase-file codebase="k8s-workshop" path="code/00-node/01.Node-label.yaml" lang="yaml" ref="master" hidden="true"}}

**Verify that your chosen node as role=schedule label applied.**

    kubectl get nodes --show-labels

<i class="fa fa-spinner fa-pulse fa-fw"></i> The output will be similar to this

    NAME       STATUS    ROLES     AGE       VERSION   LABELS
    vm-1234    Ready     <none>    36h       v1.12.4   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=minikube,role=schedule

## Clean-up
Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `00-node/_1.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/00-node/_1.clean.sh" lang="bash" ref="master" hidden="true"}}


# Wrap-up
<ul class="fa-ul">
  <li><i class="fa-li fa fa-check-square"></i>How to assign a label to a node</li>
  <li><i class="fa-li fa fa-check-square"></i>Using both kubectl and manifest to apply changes</li>
</ul>
