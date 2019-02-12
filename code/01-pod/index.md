> **Tip**
> 
> ***Time to complete 30ms***

A pod is the atom of K8s. It is the fundamental unit of deployment with
a group of one or more containers (such as Docker containers), with
shared storage/network, and a specification for how to run the
containers.

In this exercise, we shall cover the following operations using K8s
manifests,

  - ✓ Creating a *Pod*

  - ✓ *cgroup* resources and limits

  - ✓ *Healthcheck*

  - ✓ *Lifecycle* hooks

  - ✓ *Pod:Node* association

> **Note**
> 
> Will install all the objects to the *default* namespace.

# Pod

## Create an atom

**List the pods in the default namespace.**

``` go-cli
kubectl get pods
```

> **Note**
> 
> The output will be similar to this,

    No resources found.

{checkedbox} **kubectl apply -f 01-Pod/01.Pod.yaml**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/01-Pod/01.Pod.yaml>

**Verify that a pod named spring-music gets created.**

    kubectl get pods

> **Note**
> 
> The output will be similar to this

    NAME           READY     STATUS    RESTARTS   AGE
    spring-music      1/1       Running   0          11s

### Clean-up

{checkedbox} sh 01-Pod/\_1.clean.sh

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/01-Pod/_1.clean.sh>

> **Tip**
> 
> Unlike other manifests, only a limited fields of *Pod* spec can be
> overridden. Hence it is recommended to clean-up resources before
> moving to the next example.

## Assign Resources requests & limits

> **Note**
> 
> CPU and memory are each a resource type. A resource type has a base
> unit. CPU is specified in units of cores, and memory is specified in
> units of bytes. CPU and memory are collectively referred to as compute
> resources, or just resources. Compute resources are measurable
> quantities that can be requested, allocated, and consumed.

{checkedbox} **kubectl apply -f 01-Pod/02.Pod-resource-limit.yaml**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/01-Pod/02.Pod-resource-limit.yaml>

**Verify that a pod named spring-music gets
    created.**

    kubectl get pods/spring-music -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,CPU_REQUEST:spec.containers[*].resources.requests.cpu,CPU_LIMITT:.spec.containers[*].resources.limits.cpu,MEM_REQUEST:spec.containers[*].resources.requests.memory,MEM_LIMITT:.spec.containers[*].resources.limits.memory

> **Note**
> 
> The output will be similar to
    this

    NAME           STATUS    CPU_REQUEST   CPU_LIMITT   MEM_REQUEST   MEM_LIMITT
    spring-music      Running   250m          750m         768M          1G

> **Tip**
> 
> Although requests and limits can only be specified on individual
> Containers, a Pod resource request/limit for a particular resource
> type is the sum of the resource requests/limits of that type for each
> Container in the Pod

### Clean-up

{checkedbox} sh 01-Pod/\_1.clean.sh

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/01-Pod/_1.clean.sh>

> **Tip**
> 
> Unlike other manifests, only a limited fields of *Pod* spec can be
> overridden. Hence it is recommended to clean-up resources before
> moving to the next example.

## Health Check

> **Note**
> 
> ***Liveness probe*** is used by Kubelet to know when to restart a
> Container. For example, liveness probes could catch a deadlock, where
> an application is running, but unable to make progress. Restarting a
> Container in such a state can help to make the application more
> available despite bugs.
> 
> ***Readiness probe*** is used by Kubelete to know when a Container is
> ready to start accepting traffic.

{checkedbox} **kubectl apply -f 01-Pod/03.Pod-health-check.yaml**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/01-Pod/03.Pod-health-check.yaml>

**Verify that a pod named spring-music gets
    created.**

    kubectl get pods/spring-music -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,READINESS_PROBE:.spec.containers[*].readinessProbe.httpGet.path,LIVENESS_PROBE:.spec.containers[*].livenessProbe.httpGet.path

> **Note**
> 
> The output will be similar to this

    NAME           STATUS    READINESS_PROBE    LIVENESS_PROBE
    spring-music      Running   /actuator/health   /actuator/health

> **Tip**
> 
> A Pod is considered ready when all of its Containers are ready. One
> use of this signal is to control which Pods are used as backends for
> Services. When a Pod is not ready, it is removed from Service load
> balancers.

### Clean-up

{checkedbox} sh 01-Pod/\_1.clean.sh

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/01-Pod/_1.clean.sh>

> **Tip**
> 
> Unlike other manifests, only a limited fields of *Pod* spec can be
> overridden. Hence it is recommended to clean-up resources before
> moving to the next example.

## Lifecycle Hooks

> **Note**
> 
> There are two hooks that are exposed to Containers:
> 
>   - ***PostStart*** executes immediately after a container is created.
>     However, there is no guarantee that the hook will execute before
>     the container ENTRYPOINT. No parameters are passed to the handler.
> 
>   - ***PreStop*** is called immediately before a container is
>     terminated. It is blocking, meaning it is synchronous, so it must
>     complete before the call to delete the container can be sent. No
>     parameters are passed to the handler

{checkedbox} **kubectl apply -f 01-Pod/04.Pod-lifecycle-hook.yaml**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/01-Pod/04.Pod-lifecycle-hook.yaml>

**Verify that a pod named spring-music gets created.**

    kubectl get pods/spring-music

> **Note**
> 
> The output will be similar to this

    NAME           READY     STATUS    RESTARTS   AGE
    spring-music      1/1       Running   0          11s

**ssh to the container to look into the content of /usr/share/message
file to verify that the *postStart* script got executed.**

    kubectl exec -it spring-music -- /bin/sh
    
    more /usr/share/message

> **Important**
> 
> The output will be similar to this

    Hello Spring K8s folks

### Clean-up

{checkedbox} sh 01-Pod/\_1.clean.sh

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/01-Pod/_1.clean.sh>

> **Tip**
> 
> Unlike other manifests, only a limited fields of *Pod* spec can be
> overridden. Hence it is recommended to clean-up resources before
> moving to the next example.

## Pod Node binding

> **Note**
> 
> You can constrain a pod to only be able to run on particular nodes or
> to prefer to run on particular nodes. There are several ways to do
> this, and will look at how to use label selectors to make the
> selection

{checkedbox} **kubectl apply -f 01-Pod/05.Pod-node-selector.yaml**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/01-Pod/05.Pod-node-selector.yaml>

**Verify the output of the command.**

    kubectl get pods/spring-music

> **Warning**
> 
> The output will be similar to this

    NAME           READY     STATUS    RESTARTS   AGE
    spring-music      0/1       Pending   0          4s

Status of the pod would be pending as we have tried to assign it to a
node with label having key as *role* and value as *schedule*, but none
of the nodes will have the label. Refer [???](#Add%20labels) section to
assign the required label.

> **Note**
> 
> The output will be similar to this. Now the pod schedule should have
> happened to the node with label having key as *role* and value as
> *schedule*

    NAME           READY     STATUS    RESTARTS   AGE
    spring-music      1/1       Running   0          11s

### Clean-up

{checkedbox} **sh 01-Pod/\_1.clean.sh**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/01-Pod/_1.clean.sh>

> **Tip**
> 
> If you delete a pod, it won’t get created automatically.
