> **Tip**
> 
> ***Time to complete 15ms***

# Node labels

In this exercise, we shall look at setting labels to a K8s node. It can
be done in multiple ways. We shall look at the following options,

  - ✓ kubecl cli

  - ✓ K8s manifest

  - ❏ API

## Add labels

**List the nodes in your cluster.**

``` go-cli
kubectl get nodes -o wide
```

> **Note**
> 
> You will get an output similar to this based on the cluster size,

    NAME       STATUS    ROLES     AGE       VERSION
    vm-1234    Ready     <none>    35h       v1.12.4
    vm-4567    Ready     <none>    35h       v1.12.4

**Choose one of the nodes and add a label to it.**

``` kubectl
kubectl label nodes vm-1234 role=schedule
```

\[✔\] **sh 00-Node/\_1.apply.sh**

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
