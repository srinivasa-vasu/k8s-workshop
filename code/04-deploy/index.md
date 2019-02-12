> **Tip**
> 
> ***Time to complete 30ms***

A Deployment controller provides declarative updates for Pods and
ReplicaSets.

You describe a desired state in a Deployment object, and the Deployment
controller changes the actual state to the desired state at a controlled
rate. You can define Deployments to create new ReplicaSets, or to remove
existing Deployments and adopt all their resources with new Deployments.

In this exercise, we shall cover the following operations using K8s
manifests,

  - ✓ *Create* a *Deployment*

  - ✓ Deployment *Update Strategies*

> **Note**
> 
> Will install all the objects to the *default* namespace.

# Deployment

## Create a Deployment

**List the deployments in the default namespace.**

``` go-cli
kubectl get deploy
```

> **Note**
> 
> The output will be similar to this,

    No resources found.

{checkedbox} **kubectl apply -f 04-Deployment/01.Deployment.yaml**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/04-Deployment/01.Deployment.yaml>

**Verify the output.**

    kubectl get deploy,rs,pods

> **Note**
> 
> The output will be similar to
    this

    NAME                                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/spring-music      2         2         2            0           2m16s
    
    NAME                                           DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music-846f7447f      2         2         0         2m16s
    
    NAME                               READY     STATUS    RESTARTS   AGE
    pod/spring-music-846f7447f-znb58      1/1       Running   1          2m16s
    pod/spring-music-846f7447f-zqfs2      1/1       Running   1          2m16s

> **Note**
> 
> No need to run the clean-up script for this example.

## Update a Deployment

### Recreate

**List the deployments in the default namespace.**

``` go-cli
kubectl get deploy,rs,pods
```

> **Note**
> 
> The output will be similar to
    this

    NAME                                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/spring-music      2         2         2            0           2m16s
    
    NAME                                           DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music-846f7447f      2         2         0         2m16s
    
    NAME                               READY     STATUS    RESTARTS   AGE
    pod/spring-music-846f7447f-znb58      1/1       Running   1          2m16s
    pod/spring-music-846f7447f-zqfs2      1/1       Running   1          2m16s

**Watch the deployment in a new window.**

``` go-cli
kubectl get deploy,rs,pods
```

> **Note**
> 
> The output will be similar to
    this

    NAME                                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/spring-music      2         2         2            0           2m16s
    
    NAME                                           DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music-846f7447f      2         2         0         2m16s
    
    NAME                               READY     STATUS    RESTARTS   AGE
    pod/spring-music-846f7447f-znb58      1/1       Running   1          2m16s
    pod/spring-music-846f7447f-zqfs2      1/1       Running   1          2m16s

{checkedbox} **kubectl apply -f
04-Deployment/02.Deployment-recreate.yaml**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/04-Deployment/02.Deployment-recreate.yaml>

> **Note**
> 
> The output will be similar to
    this

    NAME                                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/spring-music      2         0         0            0           9m13s
    
    NAME                                           DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music-846f7447f      0         0         0         9m13s
    
    NAME                               READY     STATUS        RESTARTS   AGE
    pod/spring-music-846f7447f-znb58      0/1       Terminating   0          9m13s
    pod/spring-music-846f7447f-zqfs2      0/1       Terminating   0          9m13s

> **Tip**
> 
> All existing Pods are killed before new ones are created when
> *.spec.strategy.type==Recreate* and it doesn’t guarantee zero down
> time deployment

#### Clean-up

{checkedbox} sh 04-Deployment/02\_.clean.sh

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/04-Deployment/02_.clean.sh>

### RollingUpdate

{checkedbox} **kubectl apply -f 04-Deployment/03.Deployment.yaml**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/04-Deployment/03.Deployment.yaml>

**List the deployments in the default namespace.**

``` go-cli
kubectl get deploy,rs,pods
```

> **Note**
> 
> The output will be similar to
    this

    NAME                                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/spring-music      2         2         2            0           2m16s
    
    NAME                                           DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music-846f7447f      2         2         0         2m16s
    
    NAME                               READY     STATUS    RESTARTS   AGE
    pod/spring-music-846f7447f-znb58      1/1       Running   1          2m16s
    pod/spring-music-846f7447f-zqfs2      1/1       Running   1          2m16s

**Watch the deployment in a new window.**

``` go-cli
kubectl get deploy,rs,pods
```

> **Note**
> 
> The output will be similar to
    this

    NAME                                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/spring-music      2         2         2            0           2m16s
    
    NAME                                           DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music-846f7447f      2         2         0         2m16s
    
    NAME                               READY     STATUS    RESTARTS   AGE
    pod/spring-music-846f7447f-znb58      1/1       Running   1          2m16s
    pod/spring-music-846f7447f-zqfs2      1/1       Running   1          2m16s

{checkedbox} **kubectl apply -f
04-Deployment/03.Deployment-rolling-update.yaml**

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/04-Deployment/03.Deployment-rolling-update.yaml>

> **Note**
> 
> The output will be similar to
    this

    NAME                                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/spring-music      2         0         0            0           9m13s
    
    NAME                                           DESIRED   CURRENT   READY     AGE
    replicaset.extensions/spring-music-846f7447f      0         0         0         9m13s
    
    NAME                               READY     STATUS        RESTARTS   AGE
    pod/spring-music-846f7447f-znb58      0/1       Terminating   0          9m13s
    pod/spring-music-846f7447f-zqfs2      0/1       Running       0          9m13s
    pod/spring-music-846f7447f-78lwx      0/1       Running       0          22s
    pod/spring-music-8677d84f54-66fgh     0/1       Running       0          4s

> **Tip**
> 
> The Deployment updates Pods in a rolling update fashion when
> *.spec.strategy.type==RollingUpdate*. You can specify *maxUnavailable*
> and *maxSurge* to control the rolling update process
> 
> **maxUnavailable** is an optional field that specifies the maximum
> number of Pods that can be unavailable during the update process.
> 
> **maxSurge** is an optional field that specifies the maximum number of
> Pods that can be created over the desired number of Pods.

#### Clean-up

{checkedbox} sh 04-Deployment/\_1.clean.sh

> **Note**
> 
> Source:
> <https://github.com/srinivasa-vasu/k8s-workshop/blob/master/04-Deployment/_1.clean.sh>
