> **Tip**
> 
> ***Time to complete 30ms***

A ReplicaSet’s purpose is to maintain a stable set of replica Pods
running at any given time. As such, it is often used to guarantee the
availability of a specified number of identical Pods.

In this exercise, we shall cover the following operations using K8s
manifests,

  - ✓ Creating a *ReplicaSet*

  - ✓ Scheduling time *Hard* Node *Affinity*

  - ✓ Scheduling time *Soft* Node *Affinity*

  - ✓ Scheduling time *Anti-Affinity*

> **Note**
> 
> Will install all the objects to the *default* namespace.

# ReplicaSet

## Create a ReplicaSet

**List the replicasets in the default namespace.**

``` go-cli
kubectl get rs
```

> **Note**
> 
> The output will be similar to this,

    No resources found.

{checkedbox} **kubectl apply -f 02-ReplicaSet/01.ReplicaSet.yaml**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/02-ReplicaSet/01.ReplicaSet.yaml>

**Verify that a rs named spring-music gets created.**

    kubectl get rs,pods

> **Note**
> 
> The output will be similar to
    this

    NAME                                 DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music      1         1         1         6s
    
    NAME               READY     STATUS    RESTARTS   AGE
    pod/spring-music   1/1          Running   0          22m

### Clean-up

{checkedbox} sh 02-ReplicaSet/\_1.clean.sh

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/02-ReplicaSet/_1.clean.sh>

## Pod Hard Affinity

{checkedbox} **kubectl apply -f
02-ReplicaSet/02.ReplicaSet-node-affinity-hard.yaml**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/02-ReplicaSet/02.ReplicaSet-node-affinity-hard.yaml>

**Verify the output of the command.**

    kubectl get rs,pods

> **Note**
> 
> The output will be similar to
    this

    NAME                                 DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music      1         1         0         3s
    
    NAME                     READY     STATUS    RESTARTS   AGE
    pod/spring-music-j2pl2      0/1       Pending   0          3s

Status of the pod would be pending because of the affinity rule
*requiredDuringSchedulingIgnoredDuringExecution*.

> **Tip**
> 
> requiredDuringSchedulingIgnoredDuringExecution must be met for a pod
> to be scheduled onto a node. In this case it would be “only run the
> pod on nodes with with label having key as *role* and value as
> *schedule*".

Refer [???](#Add%20labels) section to assign the required label.

> **Note**
> 
> The output will be similar to
    this

    NAME                                 DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music      1         1         1         6s
    
    NAME                  READY        STATUS    RESTARTS   AGE
    pod/spring-music-j2pl2   1/1          Running   0          22m

### Clean-up

{checkedbox} sh 02-ReplicaSet/\_1.clean.sh

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/02-ReplicaSet/_1.clean.sh>

## Pod Soft Affinity

{checkedbox} **kubectl apply -f
02-ReplicaSet/03.ReplicaSet-node-affinity-soft.yaml**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/02-ReplicaSet/03.ReplicaSet-node-affinity-soft.yaml>

**Verify the output of the command.**

    kubectl get rs,pods

> **Note**
> 
> The output will be similar to
    this

    NAME                                 DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music      1         1         1         6s
    
    NAME                  READY        STATUS    RESTARTS   AGE
    pod/spring-music-j2pl2   1/1          Running   0          22m

> **Tip**
> 
> preferredDuringSchedulingIgnoredDuringExecution is a soft affinity. It
> specifies preferences that the scheduler will try to enforce but will
> not guarantee.

### Clean-up

{checkedbox} sh 02-ReplicaSet/\_1.clean.sh

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/02-ReplicaSet/_1.clean.sh>

## Anti-Affinity

{checkedbox} **kubectl apply -f
02-ReplicaSet/04.ReplicaSet-pod-antiaffinity.yaml**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/02-ReplicaSet/04.ReplicaSet-pod-antiaffinity.yaml>

**Verify the output of the command.**

    kubectl get rs,pods

> **Note**
> 
> The output will be similar to
    this

    NAME                                 DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music      2         2         0         6s
    
    NAME                     READY     STATUS    RESTARTS   AGE
    pod/spring-music-s4dcw      1/1       Running   0          5s
    pod/spring-music-tzpt8      0/1       Pending   0          5s

In this example, we are trying to run two instances of *spring-music* by
having *replicas* as 2 with one worker node.

> **Tip**
> 
> podAntiAffinity rule makes sure that instances get distributed across
> nodes and no two instances of it lands in the same node.

### Clean-up

{checkedbox} sh 02-ReplicaSet/\_1.clean.sh

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/02-ReplicaSet/_1.clean.sh>
