---
pageTitle: Let's get to Deployment
---

<md-icon class="fa fa-clock-o fa-lg" aria-hidden="true"></md-icon> Time to complete 30ms

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
A Deployment controller provides declarative updates for Pods and
ReplicaSets.

You describe a desired state in a Deployment object, and the Deployment
controller changes the actual state to the desired state at a controlled
rate. You can define Deployments to create new ReplicaSets, or to remove
existing Deployments and adopt all their resources with new Deployments.

In this exercise, we shall cover the following operations using K8s
manifests,

<ul class="fa-ul">
  <li><i class="fa-li fa fa-square"></i><b>Create</b> a <b>Deployment</b></li>
  <li><i class="fa-li fa fa-square"></i>Deployment <b>Update Strategies</b></li>
</ul>

<i class="fa fa-info-circle" aria-hidden="true"></i> Will install all the objects to the *default* namespace.

# Deployment

## Create a Deployment

**List the deployments in the default namespace.**

``` go-cli
kubectl get deploy
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    No resources found.

Create a new Deployment by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 04-deploy/01.Deployment.yaml`

{{codebase-file codebase="k8s-workshop" path="code/04-deploy/01.Deployment.yaml" lang="yaml" ref="master" hidden="true"}}

**Verify the output.**

    kubectl get deploy,rs,pods

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

    NAME                                    DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/spring-music      2         2         2            0           2m16s
    
    NAME                                              DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music-846f7447f      2         2         0         2m16s
    
    NAME                                  READY     STATUS    RESTARTS   AGE
    pod/spring-music-846f7447f-znb58      1/1       Running   1          2m16s
    pod/spring-music-846f7447f-zqfs2      1/1       Running   1          2m16s


No need to run the clean-up script for this example.

## Update a Deployment

### Recreate

**List the deployments in the default namespace.**

``` go-cli
kubectl get deploy,rs,pods
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    NAME                                    DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/spring-music      2         2         2            0           2m16s
    
    NAME                                              DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music-846f7447f      2         2         0         2m16s
    
    NAME                                  READY     STATUS    RESTARTS   AGE
    pod/spring-music-846f7447f-znb58      1/1       Running   1          2m16s
    pod/spring-music-846f7447f-zqfs2      1/1       Running   1          2m16s

**Watch the deployment in a new window.**

``` go-cli
watch kubectl get deploy,rs,pods
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    NAME                                    DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/spring-music      2         2         2            0           2m16s
    
    NAME                                              DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music-846f7447f      2         2         0         2m16s
    
    NAME                                  READY     STATUS    RESTARTS   AGE
    pod/spring-music-846f7447f-znb58      1/1       Running   1          2m16s
    pod/spring-music-846f7447f-zqfs2      1/1       Running   1          2m16s


Update the Deployment object by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 04-deploy/02.Deployment-recreate.yaml`
                                                     
{{codebase-file codebase="k8s-workshop" path="code/04-deploy/02.Deployment-recreate.yaml" lang="yaml" ref="master" hidden="true"}}

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this in the watch window,

    NAME                                    DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/spring-music      2         0         0            0           9m13s
    
    NAME                                              DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music-846f7447f      0         0         0         9m13s
    
    NAME                                  READY     STATUS        RESTARTS   AGE
    pod/spring-music-846f7447f-znb58      0/1       Terminating   0          9m13s
    pod/spring-music-846f7447f-zqfs2      0/1       Terminating   0          9m13s

<i class="fa fa-exclamation-circle fa-lg" aria-hidden="true" style="color:maroon"></i>
All existing Pods are killed before new ones are created when
*.spec.strategy.type==Recreate* and it doesn’t guarantee zero down
time deployment

#### Clean-up

Exit the watch window and run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `04-deploy/02_.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/04-deploy/02_.clean.sh" lang="bash" ref="master" hidden="true"}}

### RollingUpdate

Create a new Deployment by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 04-deploy/03.Deployment.yaml`

{{codebase-file codebase="k8s-workshop" path="code/04-deploy/03.Deployment.yaml" lang="yaml" ref="master" hidden="true"}}

**List the deployments in the default namespace.**

``` go-cli
kubectl get deploy,rs,pods
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,


    NAME                                    DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/spring-music      2         2         2            0           2m16s
    
    NAME                                              DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music-846f7447f      2         2         0         2m16s
    
    NAME                                  READY     STATUS    RESTARTS   AGE
    pod/spring-music-846f7447f-znb58      1/1       Running   1          2m16s
    pod/spring-music-846f7447f-zqfs2      1/1       Running   1          2m16s

**Watch the deployment in a new window.**

``` go-cli
watch kubectl get deploy,rs,pods
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    NAME                                    DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/spring-music      2         2         2            0           2m16s
    
    NAME                                              DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music-846f7447f      2         2         0         2m16s
    
    NAME                                  READY     STATUS    RESTARTS   AGE
    pod/spring-music-846f7447f-znb58      1/1       Running   1          2m16s
    pod/spring-music-846f7447f-zqfs2      1/1       Running   1          2m16s


Update the Deployment object by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 04-deploy/03.Deployment-rolling-update.yaml`
                                                     
{{codebase-file codebase="k8s-workshop" path="code/04-deploy/03.Deployment-rolling-update.yaml" lang="yaml" ref="master" hidden="true"}}

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this in the watch window,
 
    NAME                                    DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/spring-music      2         0         0            0           9m13s
    
    NAME                                              DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music-846f7447f      0         0         0         9m13s
    
    NAME                                  READY     STATUS        RESTARTS   AGE
    pod/spring-music-846f7447f-znb58      0/1       Terminating   0          9m13s
    pod/spring-music-846f7447f-zqfs2      1/1       Running       0          9m13s
    pod/spring-music-846f7447f-78lwx      1/1       Running       0          22s
    pod/spring-music-8677d84f54-66fgh     1/1       Running       0          4s

The Deployment updates Pods in a rolling update fashion when
*.spec.strategy.type==RollingUpdate*. You can specify *maxUnavailable*
and *maxSurge* to control the rolling update process
 
**maxUnavailable** is an optional field that specifies the maximum
number of Pods that can be unavailable during the update process.
 
**maxSurge** is an optional field that specifies the maximum number of
Pods that can be created over the desired number of Pods.

#### Clean-up

Exit the watch window and run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `04-deploy/03_.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/04-deploy/03_.clean.sh" lang="bash" ref="master" hidden="true"}}


#Wrap-up
<ul class="fa-ul">
  <li><i class="fa-li fa fa-check-square"></i><b>Create</b> a <b>Deployment</b></li>
  <li><i class="fa-li fa fa-check-square"></i>Deployment <b>Update Strategies</b></li>
</ul>
