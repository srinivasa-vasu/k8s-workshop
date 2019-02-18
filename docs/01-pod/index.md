---
pageTitle: Pods - Atom of K8s
---

<md-icon class="fa fa-clock-o fa-lg" aria-hidden="true"></md-icon> Time to complete 30ms

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
Pod is the atom of K8s. It is the fundamental unit of deployment with
a group of one or more containers (such as Docker containers), with
shared storage/network, and a specification for how to run the
containers.

In this exercise, we shall cover the following operations using K8s
manifests,

<ul class="fa-ul">
  <li><i class="fa-li fa fa-square"></i>Creating a <b>Pod</b></li>
  <li><i class="fa-li fa fa-square"></i>cgroup <b>resources</b> and <b>limits</b></li>
  <li><i class="fa-li fa fa-square"></i><b>Healthcheck</b></li>
  <li><i class="fa-li fa fa-square"></i>Lifecycle <b>hooks</b></li>
  <li><i class="fa-li fa fa-square"></i><b>Pod:Node</b> association</li>
</ul>

<i class="fa fa-info-circle" aria-hidden="true"></i> Will install all the objects to the *default* namespace.

# Pod

## Create an atom

**List the pods in the default namespace**

``` go-cli
kubectl get pods
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    No resources found.


Create a new Pod by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 01-pod/01.Pod.yaml`

{{codebase-file codebase="k8s-workshop" path="code/01-pod/01.Pod.yaml" lang="yaml" ref="master" hidden="true"}}

**Verify that a pod named spring-music gets created**

    kubectl get pods

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

    NAME              READY     STATUS    RESTARTS   AGE
    spring-music      1/1       Running   0          11s

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `01-pod/_1.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/01-pod/_1.clean.sh" lang="bash" ref="master" hidden="true"}}

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
Unlike other manifests, only a limited fields of *Pod* spec can be overridden. Hence it is recommended to clean-up resources before moving to the next example.

## Assign Resources requests & limits

CPU and memory are each a resource type. A resource type has a base unit. CPU is specified in units of cores, and memory is specified in
units of bytes. CPU and memory are collectively referred to as compute resources, or just resources. Compute resources are measurable
quantities that can be requested, allocated, and consumed.

Create a new Pod by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 01-pod/02.Pod-resource-limit.yaml`

{{codebase-file codebase="k8s-workshop" path="code/01-pod/02.Pod-resource-limit.yaml" lang="yaml" ref="master" hidden="true"}}

**Verify that a pod named spring-music gets created**

    kubectl get pods/spring-music -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,CPU_REQUEST:spec.containers[*].resources.requests.cpu,CPU_LIMITT:.spec.containers[*].resources.limits.cpu,MEM_REQUEST:spec.containers[*].resources.requests.memory,MEM_LIMITT:.spec.containers[*].resources.limits.memory

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

    NAME              STATUS    CPU_REQUEST   CPU_LIMITT   MEM_REQUEST   MEM_LIMITT
    spring-music      Running   250m          750m         768M          1G

<i class="fa fa-bell fa-lg" aria-hidden="true" style="color:orange"></i> 
Although requests and limits can only be specified on individual Containers, a Pod resource request/limit for a particular resource
type is the sum of the resource requests/limits of that type for each Container in the Pod

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `01-pod/_1.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/01-pod/_1.clean.sh" lang="bash" ref="master" hidden="true"}}

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
Unlike other manifests, only a limited fields of *Pod* spec can be overridden. Hence it is recommended to clean-up resources before moving to the next example.

## Health Check

***Liveness probe*** is used by Kubelet to know when to restart a Container. For example, liveness probes could catch a deadlock, where an application is running, but unable to make progress. Restarting a
Container in such a state can help to make the application more available despite bugs.

***Readiness probe*** is used by Kubelete to know when a Container is ready to start accepting traffic.

Create a new Pod by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 01-pod/03.Pod-health-check.yaml`

{{codebase-file codebase="k8s-workshop" path="code/01-pod/03.Pod-health-check.yaml" lang="bash" ref="master" hidden="true"}}

**Verify that a pod named spring-music gets created**

    kubectl get pods/spring-music -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,READINESS_PROBE:.spec.containers[*].readinessProbe.httpGet.path,LIVENESS_PROBE:.spec.containers[*].livenessProbe.httpGet.path

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

    NAME              STATUS    READINESS_PROBE    LIVENESS_PROBE
    spring-music      Running   /actuator/health   /actuator/health

<i class="fa fa-bell fa-lg" aria-hidden="true" style="color:orange"></i>
A Pod is considered ready when all of its Containers are ready. One use of this signal is to control which Pods are used as backends for Services. When a Pod is not ready, it is removed from Service load balancers.

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `01-pod/_1.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/01-pod/_1.clean.sh" lang="bash" ref="master" hidden="true"}}

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
Unlike other manifests, only a limited fields of *Pod* spec can be overridden. Hence it is recommended to clean-up resources before moving to the next example.


## Lifecycle Hooks

There are two hooks that are exposed to Containers:
   - ***PostStart*** executes immediately after a container is created. However, there is no guarantee that the hook will execute before the container ENTRYPOINT. No parameters are passed to the handler.
   - ***PreStop*** is called immediately before a container is terminated. It is blocking, meaning it is synchronous, so it must complete before the call to delete the container can be sent. No parameters are passed to the handler


Create a new Pod by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 01-pod/04.Pod-lifecycle-hook.yaml`

{{codebase-file codebase="k8s-workshop" path="code/01-pod/04.Pod-lifecycle-hook.yaml" lang="bash" ref="master" hidden="true"}}

**Verify that a pod named spring-music gets created**

    kubectl get pods/spring-music

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

    NAME              READY     STATUS    RESTARTS   AGE
    spring-music      1/1       Running   0          11s

<i class="fa fa-thumbs-up" aria-hidden="true" style="color:green"></i> ssh to the container to look into the content of /usr/share/message
file to verify that the *postStart* script got executed.

    kubectl exec -it spring-music -- /bin/sh
    
    more /usr/share/message

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

    Hello Spring K8s folks

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `01-pod/_1.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/01-pod/_1.clean.sh" lang="bash" ref="master" hidden="true"}}

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
Unlike other manifests, only a limited fields of *Pod* spec can be overridden. Hence it is recommended to clean-up resources before moving to the next example.

## Pod Node binding

You can constrain a pod to only be able to run on particular nodes or to prefer to run on particular nodes. There are several ways to do this, and will look at how to use label selectors to make the selection

Create a new Pod by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 01-pod/05.Pod-node-selector.yaml`

{{codebase-file codebase="k8s-workshop" path="code/01-pod/05.Pod-node-selector.yaml" lang="bash" ref="master" hidden="true"}}


**Verify the output of the command**

    kubectl get pods/spring-music


<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

    NAME              READY     STATUS    RESTARTS   AGE
    spring-music      0/1       Pending   0          4s

<i class="fa fa-exclamation-circle fa-lg" aria-hidden="true" style="color:maroon"></i>
Status of the pod would be pending as we have tried to assign it to a
node with label having key as *role* and value as *schedule*, but none
of the nodes will have the label. Refer [Add labels](../00-node/index.html#add_labels) section to
assign the required label.

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
The output will be similar to this. Now the pod schedule should have
happened to the node with label having key as *role* and value as
*schedule*

    NAME              READY     STATUS    RESTARTS   AGE
    spring-music      1/1       Running   0          11s

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `01-pod/_1.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/01-pod/_1.clean.sh" lang="bash" ref="master" hidden="true"}}

<i class="fa fa-exclamation-circle fa-lg" aria-hidden="true" style="color:maroon"></i>
Pls note if you delete a pod, it won’t get created automatically. K8s will not try to resurrect/recreate the deleted pod

# Wrap-up
<ul class="fa-ul">
  <li><i class="fa-li fa fa-check-square"></i>Creating a Pod</li>
  <li><i class="fa-li fa fa-check-square"></i>Controlling pod resources and limits</li>
  <li><i class="fa-li fa fa-check-square"></i>Enabling health checks</li>
  <li><i class="fa-li fa fa-check-square"></i>Creating Lifecycle hooks</li>
  <li><i class="fa-li fa fa-check-square"></i>Binding pod to a node</li>
</ul>
