---
pageTitle: Pod initialization Phases
---

<md-icon class="fa fa-clock-o fa-lg" aria-hidden="true"></md-icon> Time to complete 30ms

In case of multi-app deployments, there may be cases where one app may have a dependency on the other. In such cases, you might want to hold the container creation of the dependent app before the parent app gets initialized fully. 
Even in case of single app deployment, you might have requirements to do some initialization task like copying a file, changing file access permission etc,. before the actual container gets created. InitContainers are mainly used to address 
such kind of uses cases.
  
<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
Init Containers are exactly like regular Containers, except:

- They always run to completion.
- Each one must complete successfully before the next one is started.

If an Init Container fails for a Pod, Kubernetes restarts the Pod repeatedly until the Init Container succeeds. However, if the Pod has a restartPolicy of Never, it is not restarted.

Init Containers have separate images from app Containers, they have some advantages for start-up related code:

- They can contain and run utilities that are not desirable to include in the app Container image for security reasons.
- They can contain utilities or custom code for setup that is not present in an app image.
- The application image builder and deployer roles can work independently without the need to jointly build a single app image.
- They use Linux namespaces so that they have different filesystem views from app Containers. Consequently, they can be given access to Secrets that app Containers are not able to access.
- They run to completion before any app Containers start, whereas app Containers run in parallel, so Init Containers provide an easy way to block or delay the startup of app Containers until some set of preconditions are met.


In this exercise, we shall cover the following operations using K8s
manifests,

<ul class="fa-ul">
  <li><i class="fa-li fa fa-square"></i><b>Create Init-Containers</b></li>
  <li><i class="fa-li fa fa-square"></i><b>Inspect Init-Containers</b></li>
</ul>

<i class="fa fa-info-circle" aria-hidden="true"></i> Will install all the objects to the *default* namespace.

# Init-Containers

## Create a Deployment with Init-Container

**List the deployments in the default namespace.**

``` go-cli
kubectl get deploy
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    No resources found.

Create a new multi-app Deployment by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 08-deploy-initcon/01.Service-InitContainers.yaml`

{{codebase-file codebase="k8s-workshop" path="code/08-deploy-initcon/01.Service-InitContainers.yaml" lang="yaml" ref="master" hidden="true"}}

**Verify the output**

    kubectl get deploy,rs,pods

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

```
    NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/jhipapp              0/1     1            0           49s
    deployment.extensions/jhipapp-postgresql   1/1     1            1           49s
    
    NAME                                                  DESIRED   CURRENT   READY   AGE
    replicaset.extensions/jhipapp-b89f9b655               1         1         0       1s
    replicaset.extensions/jhipapp-postgresql-846b69457d   1         1         1       49s
    
    NAME                                      READY   STATUS                  RESTARTS   AGE
    pod/jhipapp-b89f9b655-srjbm               0/1     Init:0/1                0          1s
    pod/jhipapp-postgresql-846b69457d-wgjwt   1/1     Running                 0          49s
```

This time `pod/jhipapp-b89f9b655-srjbm` status is something different `Init:0/1`. As the application `pod/jhipapp-b89f9b655-srjbm` is dependent on the
database `pod/jhipapp-postgresql-846b69457d-wgjwt`, if the app pod gets created sooner than the database pod and if it won't get initialized fully (if the liveness probe fails), then
Kubelet will keep restarting the app pod. This happens, ff the database pod takes longer than the liveness threshold of app pod to get created.

To avoid this we can use init-Containers in app pod to check the status of database pod.

If you look at the manifest of app,

```
      initContainers:
        - name: init-ds
          image: busybox:latest
          imagePullPolicy: IfNotPresent
          command:
            - '/bin/sh'
            - '-c'
            - |
              while true
              do
                rt=$(nc -z -w 1 jhipapp-postgresql 5432)
                if [ $? -eq 0 ]; then
                  echo "DB is UP"
                  break
                fi
                echo "DB is not yet reachable;sleep for 10s before retry"
                sleep 10
              done
```

Here in the initialization container, we are checking whether the database pod is fully created. If not, it will sleep for 10s before it repeats the same. Main container of the app won't be created until the init-container runs to completion. 

**Verify the output again in sometime**

    kubectl get deploy,rs,pods

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

```
    NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/jhipapp              1/1     1            1           10m
    deployment.extensions/jhipapp-postgresql   1/1     1            1           10m
    
    NAME                                                  DESIRED   CURRENT   READY   AGE
    replicaset.extensions/jhipapp-b89f9b655               1         1         1       10m
    replicaset.extensions/jhipapp-postgresql-846b69457d   1         1         1       10m
    
    NAME                                      READY   STATUS    RESTARTS   AGE
    pod/jhipapp-b89f9b655-srjbm               1/1     Running   0          10m
    pod/jhipapp-postgresql-846b69457d-wgjwt   1/1     Running   0          10m
```

## Inspect Init-Containers

**Run the below command to look into init-containers in a pod**

`kubectl get  pod/jhipapp-b89f9b655-srjbm  -o jsonpath={".spec.initContainers[*].name"}` 

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

`init-ds%`

**To verify the init-container logs**

`kubectl logs pod/jhipapp-b89f9b655-srjbm -c init-ds`

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

`DB is UP%`


### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `08-deploy-initcon/_1.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/08-deploy-initcon/_1.clean.sh" lang="bash" ref="master" hidden="true"}}


#Wrap-up
<ul class="fa-ul">
  <li><i class="fa-li fa fa-check-square"></i><b>Create Init-Containers</b></li>
  <li><i class="fa-li fa fa-check-square"></i><b>Inspect Init-Containers</b></li>
</ul>
