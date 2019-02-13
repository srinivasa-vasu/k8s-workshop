---
pageTitle: Node Pod Association
---

<md-icon class="fa fa-clock-o fa-lg" aria-hidden="true"></md-icon> Time to complete 30ms

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
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

<ul class="fa-ul">
  <li><i class="fa-li fa fa-square"></i><b>Tolerating</b> a Node <b>Taint</b></li>
  <li><i class="fa-li fa fa-square"></i><b>Un-tolerating</b> a Node <b>Taint</b></li>
  <li><i class="fa-li fa fa-square"></i><b>Runtime </b> addition of a new Node <b>Taint</b></li>
</ul>

<i class="fa fa-info-circle" aria-hidden="true"></i> Will install all the objects to the *default* namespace.

# Taint and Tolerations

## Tolerate a Taint

**List the replicasets in the default namespace.**

``` go-cli
kubectl get rs
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    No resources found.

Create node and pod related changes by running the script <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `sh 03-no-po/01_.apply.sh`

{{codebase-file codebase="k8s-workshop" path="code/03-no-po/01_.apply.sh" lang="bash" ref="master" hidden="true"}}

Source of the associated K8s manifest,

{{codebase-file codebase="k8s-workshop" path="code/03-no-po/01.Node-taint-match.yaml" lang="yaml" ref="master" hidden="true"}}

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    kubectl get nodes -o yaml -o jsonpath={".items[*].spec.taints}"
    
    [map[effect:NoSchedule key:dedicated value:host]]
    
    kubectl get pods -o yaml -o jsonpath={".items[*].spec.tolerations}"
    
    [map[effect:NoSchedule key:dedicated operator:Equal value:host]

It places a *taint* on the chosen node with key as dedicated, value as
host, and taint effect NoSchedule. This means that no pod will be able
to schedule onto the node unless it has a matching toleration. To
schedule a pod onto the node we have to have matching *toleration* in
the PodSpec

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `03-no-po/01_.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/03-no-po/01_.clean.sh" lang="bash" ref="master" hidden="true"}}

## Un-tolerate a Taint

**List the replicasets in the default namespace.**

``` go-cli
kubectl get rs
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    No resources found.


Create node and pod related changes by running the script <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `sh 03-no-po/02_.apply.sh`

{{codebase-file codebase="k8s-workshop" path="code/03-no-po/02_.apply.sh" lang="bash" ref="master" hidden="true"}}


Source of the associated K8s manifest,

{{codebase-file codebase="k8s-workshop" path="code/03-no-po/02.Node-taint-no-match.yaml" lang="yaml" ref="master" hidden="true"}}


<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    kubectl get nodes -o yaml -o jsonpath={".items[*].spec.taints}"
    
    [map[effect:NoSchedule key:dedicated value:host]]
    
    kubectl get pods -o yaml -o jsonpath={".items[*].spec.tolerations}"
    
    [map[]]
    
    kubectl get rs,pods
    NAME                                    DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music      1         1         0         20s
    
    NAME                        READY     STATUS    RESTARTS   AGE
    pod/spring-music-vbbkl      0/1       Pending   0          20s

<i class="fa fa-exclamation-circle fa-lg" aria-hidden="true" style="color:maroon"></i>
Pod will be in pending state as it can’t tolerate the taint

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `03-no-po/02_.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/03-no-po/02_.clean.sh" lang="bash" ref="master" hidden="true"}}

## Runtime Taint

**List the replicasets in the default namespace.**

``` go-cli
kubectl get rs
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    No resources found.



Create node and pod related changes by running the script <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `sh 03-no-po/02_.apply.sh`

{{codebase-file codebase="k8s-workshop" path="code/03-no-po/03_.apply.sh" lang="bash" ref="master" hidden="true"}}

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,


    watch kubectl get pods
    Every 2.0s: kubectl get pods                                                                                                                                                                           sv.local: Sun Feb 10 16:05:03 2019
    
    NAME                 READY     STATUS    RESTARTS   AGE
    spring-music-6mdvd   1/1       Running   0          11s
    
    NAME                 READY     STATUS    RESTARTS   AGE
    spring-music-w72zv   0/1       Pending   0          42s

It places a *taint* on the chosen node with key as dedicated, value as
host, and taint effect NoSchedule. This means that no pod will be able
to schedule onto the node unless it has a matching toleration. As the
pod has a matching *toleration* it would get scheduled on the node and
hence the status was initially Running. After few seconds, it would
get updated to Pending as the addition of a new Runtime *NoExecute*
operator would make the pod un-tolerate the taint.

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `03-no-po/03_.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/03-no-po/03_.clean.sh" lang="bash" ref="master" hidden="true"}}


# Wrap-up
<ul class="fa-ul">
  <li><i class="fa-li fa fa-check-square"></i><b>Tolerating</b> a Node <b>Taint</b></li>
  <li><i class="fa-li fa fa-check-square"></i><b>Un-tolerating</b> a Node <b>Taint</b></li>
  <li><i class="fa-li fa fa-check-square"></i><b>Runtime </b> addition of a new Node <b>Taint</b></li>
</ul>
