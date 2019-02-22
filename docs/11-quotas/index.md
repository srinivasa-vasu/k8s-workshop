---
pageTitle: Control Quota
---

<md-icon class="fa fa-clock-o fa-lg" aria-hidden="true"></md-icon> Time to complete 30ms

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
A resource quota, defined by a ResourceQuota object, provides constraints that limit aggregate resource consumption per namespace. It can limit the quantity of objects that can be created in a namespace by type, as well as the total amount of compute resources that may be consumed by resources in that project.

A limit range, defined by a LimitRange object, enumerates compute resource constraints in a project at the pod, container, image, image stream, and persistent volume claim level, and specifies the amount of resources that a pod, container, image, image stream, or persistent volume claim can consume

In this exercise, we shall cover the following operations using K8s
manifests,

<ul class="fa-ul">
  <li><i class="fa-li fa fa-square"></i><b>Resource Quota</b></li>
  <li><i class="fa-li fa fa-square"></i><b>Limit Range</b></li>
</ul>

<i class="fa fa-info-circle" aria-hidden="true"></i> Will install all the objects to the *default* namespace.

# Resource Quota

## Set Memory and CPU Quota

**List the resourcequota in the default namespace**

``` go-cli
kubectl get resourcequota
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    No resources found.

Create a new ResourceQuota by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 11-quotas/01.ResourceQuota.yaml`

{{codebase-file codebase="k8s-workshop" path="code/11-quotas/01.ResourceQuota.yaml" lang="yaml" ref="master" hidden="true"}}


**Verify the resourcequota definition**

``` go-cli
kubectl describe resourcequota cpu-mem-quota
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be exactly like this,

```
    Name:            cpu-mem-quota
    Namespace:       default
    Resource         Used  Hard
    --------         ----  ----
    limits.cpu       0     2
    limits.memory    0     2G
    requests.cpu     0     1
    requests.memory  0     1G
```


Create a new Deployment by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 11-quotas/02.Pod-no-resource-limit.yaml`

{{codebase-file codebase="k8s-workshop" path="code/11-quotas/02.Pod-no-resource-limit.yaml" lang="yaml" ref="master" hidden="true"}}


**Verify the output**

``` error
Error from server (Forbidden): error when creating "11-quotas/02.Pod-no-resource-limit.yaml": pods "spring-music" is forbidden: failed quota: cpu-mem-quota: must specify limits.cpu,limits.memory,requests.cpu,requests.memory
```

If you inspect the definition of the deployment, it doesn't include the resource constraints. Once the quota is set at **Namespace** level, any deployment that happens in that Namespace should request for the entity of the configured ResourceQuota.

```
spec:
  containers:
  - name: spring-music
    image: humourmind/spring-music:blue
    imagePullPolicy: Always
    ports:
    - name: web
      containerPort: 8080
```

Create a new Deployment by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 11-quotas/03.Pod-resource-limit.yaml`

{{codebase-file codebase="k8s-workshop" path="code/11-quotas/03.Pod-resource-limit.yaml" lang="yaml" ref="master" hidden="true"}}

This should get deployed without any issues.

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `sh 11-quotas/03_.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/11-quotas/03_.clean.sh" lang="bash" ref="master" hidden="true"}}


## Set default Limit Range

Create a new LimitRange by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 11-quotas/04-LimitRange-default.yaml`

{{codebase-file codebase="k8s-workshop" path="code/11-quotas/04-LimitRange-default.yaml" lang="yaml" ref="master" hidden="true"}}


**Verify the limitrange definition**

``` go-cli
kubectl describe limitrange cpu-mem-default
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be exactly like this,

```
    Name:       cpu-mem-default
    Namespace:  default
    Type        Resource  Min  Max  Default Request  Default Limit  Max Limit/Request Ratio
    ----        --------  ---  ---  ---------------  -------------  -----------------------
    Container   memory    -    -    756M             1G             -
    Container   cpu       -    -    500m             1              -
```

Create a new Deployment without requesting resource constraints by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 11-quotas/02.Pod-no-resource-limit.yaml`

{{codebase-file codebase="k8s-workshop" path="code/11-quotas/02.Pod-no-resource-limit.yaml" lang="yaml" ref="master" hidden="true"}}

This time deployment should get through without any issues. Now the deployment should get assigned with resource definition from the **LimitRange** object. Inspect the deployment to identify the changes.

**Verify the pod definition**

``` go-cli
kubectl get pod/spring-music -o yaml
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar like this,

```
    spec:
      containers:
      - image: humourmind/spring-music:blue
        imagePullPolicy: Always
        name: spring-music
        ports:
        - containerPort: 8080
          name: web
          protocol: TCP
        resources:
          limits:
            cpu: "1"
            memory: 1G
          requests:
            cpu: 500m
            memory: 756M
```

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `sh 11-quotas/04_.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/11-quotas/04_.clean.sh" lang="bash" ref="master" hidden="true"}}


## Set max Limit Range

Create a new LimitRange by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 11-quotas/05-LimitRange-min-max.yaml`

{{codebase-file codebase="k8s-workshop" path="code/11-quotas/05-LimitRange-min-max.yaml" lang="yaml" ref="master" hidden="true"}}


**Verify the limitrange definition**

``` go-cli
kubectl describe resourcequota cpu-mem-max-min
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be exactly like this,

```
    Name:       cpu-mem-max-min
    Namespace:  default
    Type        Resource  Min   Max  Default Request  Default Limit  Max Limit/Request Ratio
    ----        --------  ---   ---  ---------------  -------------  -----------------------
    Container   cpu       500m  1    1                1              -
    Container   memory    512M  1G   1G               1G             -
```

Create a new Deployment without requesting resource constraints by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 11-quotas/02.Pod-no-resource-limit.yaml`

{{codebase-file codebase="k8s-workshop" path="code/11-quotas/02.Pod-no-resource-limit.yaml" lang="yaml" ref="master" hidden="true"}}

This time deployment should get through without any issues. Now the deployment should get assigned with resource definition from the **LimitRange** object. Inspect the deployment to identify the changes.

**Verify the pod definition**

``` go-cli
kubectl get pod/spring-music -o yaml
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar like this,

```
    spec:
      containers:
      - image: humourmind/spring-music:blue
        imagePullPolicy: Always
        name: spring-music
        ports:
        - containerPort: 8080
          name: web
          protocol: TCP
        resources:
          limits:
            cpu: "1"
            memory: 1G
          requests:
            cpu: "1"
            memory: 1G
```

Since there is no default limit, max limit will be set for both requests and limits of the pod object.

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `sh 11-quotas/05_.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/11-quotas/05_.clean.sh" lang="bash" ref="master" hidden="true"}}


# Wrap-up
<ul class="fa-ul">
  <li><i class="fa-li fa fa-check-square"></i><b>Resource Quota</b></li>
  <li><i class="fa-li fa fa-check-square"></i><b>Limit Range</b></li>
</ul>
