---
pageTitle: It's the ReplicaSet
---

<md-icon class="fa fa-clock-o fa-lg" aria-hidden="true"></md-icon> Time to complete 30ms

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
A ReplicaSet’s purpose is to maintain a stable set of replica Pods
running at any given time. As such, it is often used to guarantee the
availability of a specified number of identical Pods.

In this exercise, we shall cover the following operations using K8s
manifests,

<ul class="fa-ul">
  <li><i class="fa-li fa fa-square"></i>Creating a <b>ReplicaSet</b></li>
  <li><i class="fa-li fa fa-square"></i>Scheduling time <b>Hard</b> Node <b>Affinity</b></li>
  <li><i class="fa-li fa fa-square"></i>Scheduling time <b>Soft</b> Node <b>Affinity</b></li>
  <li><i class="fa-li fa fa-square"></i>Scheduling time <b>Anti-Affinity</b></li>
</ul>

<i class="fa fa-info-circle" aria-hidden="true"></i> Will install all the objects to the *default* namespace.
  

# ReplicaSet

## Create a ReplicaSet

**List the replicasets in the default namespace.**

``` go-cli
kubectl get rs
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    No resources found.

Create a new ReplicaSet by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 02-rs/01.ReplicaSet.yaml`

{{codebase-file codebase="k8s-workshop" path="code/02-rs/01.ReplicaSet.yaml" lang="yaml" ref="master" hidden="true"}}


**Verify that a rs named spring-music gets created.**

    kubectl get rs,pods

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

    NAME                                    DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music      1         1         1         6s
    
    NAME               READY        STATUS    RESTARTS   AGE
    pod/spring-music   1/1          Running   0          22m

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `02-rs/_1.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/02-rs/_1.clean.sh" lang="bash" ref="master" hidden="true"}}


## Pod Hard Affinity

Create a new ReplicaSet by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 02-rs/02.ReplicaSet-node-affinity-hard.yaml`

{{codebase-file codebase="k8s-workshop" path="code/02-rs/02.ReplicaSet-node-affinity-hard.yaml" lang="yaml" ref="master" hidden="true"}}

**Verify the output of the command.**

    kubectl get rs,pods

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

    NAME                                 DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music      1         1         0         3s
    
    NAME                        READY     STATUS    RESTARTS   AGE
    pod/spring-music-j2pl2      0/1       Pending   0          3s

Status of the pod would be pending because of the affinity rule
*requiredDuringSchedulingIgnoredDuringExecution*.

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
requiredDuringSchedulingIgnoredDuringExecution must be met for a pod
to be scheduled onto a node. In this case it would be “only run the
pod on nodes with with label having key as *role* and value as
*schedule*.

Refer [Add labels](../node/index.html#add_labels) section to
assign the required label.


<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

    NAME                                 DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music      1         1         1         6s
    
    NAME                     READY        STATUS    RESTARTS   AGE
    pod/spring-music-j2pl2   1/1          Running   0          22m

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `02-rs/_1.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/02-rs/_1.clean.sh" lang="bash" ref="master" hidden="true"}}


## Pod Soft Affinity

Create a new ReplicaSet by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 02-rs/03.ReplicaSet-node-affinity-soft.yaml`

{{codebase-file codebase="k8s-workshop" path="code/02-rs/03.ReplicaSet-node-affinity-soft.yaml" lang="yaml" ref="master" hidden="true"}}


**Verify the output of the command.**

    kubectl get rs,pods

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

    NAME                                 DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music      1         1         1         6s
    
    NAME                     READY        STATUS    RESTARTS   AGE
    pod/spring-music-j2pl2   1/1          Running   0          22m


<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
preferredDuringSchedulingIgnoredDuringExecution is a soft affinity. It
specifies preferences that the scheduler will try to enforce but will
not guarantee.

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `02-rs/_1.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/02-rs/_1.clean.sh" lang="bash" ref="master" hidden="true"}}


## Anti-Affinity

Create a new ReplicaSet by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 02-rs/04.ReplicaSet-pod-antiaffinity.yaml`

{{codebase-file codebase="k8s-workshop" path="code/02-rs/04.ReplicaSet-pod-antiaffinity.yaml" lang="yaml" ref="master" hidden="true"}}


**Verify the output of the command.**

    kubectl get rs,pods

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

    NAME                                    DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music      2         2         0         6s
    
    NAME                        READY     STATUS    RESTARTS   AGE
    pod/spring-music-s4dcw      1/1       Running   0          5s
    pod/spring-music-tzpt8      0/1       Pending   0          5s

In this example, we are trying to run two instances of *spring-music* by
having *replicas* as 2 with one worker node.

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i> 
podAntiAffinity rule makes sure that instances get distributed across nodes and no two instances of it lands in the same node.

### Clean-up

{checkedbox} sh 02-ReplicaSet/\_1.clean.sh

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `02-rs/_1.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/02-rs/_1.clean.sh" lang="bash" ref="master" hidden="true"}}


# Wrap-up
<ul class="fa-ul">
  <li><i class="fa-li fa fa-check-square"></i>Creating a <b>ReplicaSet</b></li>
  <li><i class="fa-li fa fa-check-square"></i>Scheduling time <b>Hard</b> Node <b>Affinity</b></li>
  <li><i class="fa-li fa fa-check-square"></i>Scheduling time <b>Soft</b> Node <b>Affinity</b></li>
  <li><i class="fa-li fa fa-check-square"></i>Scheduling time <b>Anti-Affinity</b></li>
</ul>
