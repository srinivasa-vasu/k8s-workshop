> **Tip**
> 
> ***Time to complete 30ms***

Node affinity, is a property of pods that attracts them to a set of
nodes (either as a preference or a hard requirement). Taints are the
opposite – they allow a node to repel a set of pods.

Taints and tolerations work together to ensure that pods are not
scheduled onto inappropriate nodes. One or more taints are applied to a
node; this marks that the node should not accept any pods that do not
tolerate the taints. Tolerations are applied to pods, and allow (but do
not require) the pods to schedule onto nodes with matching taints

In this exercise, we shall cover the following operations using K8s
manifests,

  - ✓ *Tolerating* a Node *Taint*

  - ✓ *Un-tolerating* a Node *Taint*

  - ✓ *Runtime Node \_Taint*

> **Note**
> 
> Will install all the objects to the *default* namespace.

# Taint and Tolerations

## Tolerate a Taint

**List the replicasets in the default namespace.**

``` go-cli
kubectl get rs
```

> **Note**
> 
> The output will be similar to this,

    No resources found.

{checkedbox} **sh 03-Node-Pod/01\_.apply.sh**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/03-Node-Pod/01_.apply.sh>

> **Note**
> 
> The output will be similar to this

    kubectl get nodes -o yaml -o jsonpath={".items[*].spec.taints}"
    
    [map[effect:NoSchedule key:dedicated value:host]]
    
    kubectl get pods -o yaml -o jsonpath={".items[*].spec.tolerations}"
    
    [map[effect:NoSchedule key:dedicated operator:Equal value:host]

> **Note**
> 
> It places a *taint* on the chosen node with key as dedicated, value as
> host, and taint effect NoSchedule. This means that no pod will be able
> to schedule onto the node unless it has a matching toleration. To
> schedule a pod onto the node we have to have matching *toleration* in
> the PodSpec

### Clean-up

{checkedbox} sh 03-Node-Pod/\_1.clean.sh

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/03-Node-Pod/01_.clean.sh>

## Un-tolerate a Taint

**List the replicasets in the default namespace.**

``` go-cli
kubectl get rs
```

> **Note**
> 
> The output will be similar to this,

    No resources found.

{checkedbox} **sh 03-Node-Pod/02\_.apply.sh**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/03-Node-Pod/02_.apply.sh>

> **Note**
> 
> The output will be similar to this

    kubectl get nodes -o yaml -o jsonpath={".items[*].spec.taints}"
    
    [map[effect:NoSchedule key:dedicated value:host]]
    
    kubectl get pods -o yaml -o jsonpath={".items[*].spec.tolerations}"
    
    [map[]]
    
    kubectl get rs,pods
    NAME                                 DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music      1         1         0         20s
    
    NAME                     READY     STATUS    RESTARTS   AGE
    pod/spring-music-vbbkl      0/1       Pending   0          20s

> **Note**
> 
> Pod will be in pending state as it can’t tolerate the taint

### Clean-up

{checkedbox} sh 03-Node-Pod/\_1.clean.sh

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/03-Node-Pod/02_.clean.sh>

## Runtime Taint

**List the replicasets in the default namespace.**

``` go-cli
kubectl get rs
```

> **Note**
> 
> The output will be similar to this,

    No resources found.

{checkedbox} **sh 03-Node-Pod/03\_.Node-taint-match-no-match-apply.sh**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/03-Node-Pod/03_.Node-taint-match-no-match-apply.sh>

> **Note**
> 
> The output will be similar to this

    watch kubectl get pods
    Every 2.0s: kubectl get pods                                                                                                                                                                           sv.local: Sun Feb 10 16:05:03 2019
    
    NAME                 READY     STATUS    RESTARTS   AGE
    spring-music-6mdvd   1/1       Running   0          11s
    
    NAME                 READY     STATUS    RESTARTS   AGE
    spring-music-w72zv   0/1       Pending   0          42s

> **Note**
> 
> It places a *taint* on the chosen node with key as dedicated, value as
> host, and taint effect NoSchedule. This means that no pod will be able
> to schedule onto the node unless it has a matching toleration. As the
> pod has a matching *toleration* it would get scheduled on the node and
> hence the status was initially Running. After few seconds, it would
> get updated to Pending as the addition of a new Runtime *NoExecute*
> operator would make the pod un-tolerate the taint.

### Clean-up

{checkedbox} sh 03-Node-Pod/03\_.clean.sh

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/03-Node-Pod/_1.clean.sh>
