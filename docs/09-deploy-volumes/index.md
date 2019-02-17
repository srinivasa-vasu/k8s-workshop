---
pageTitle: Service Discovery
---

<md-icon class="fa fa-clock-o fa-lg" aria-hidden="true"></md-icon> Time to complete 30ms

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
On-disk files in a Container are ephemeral, which presents some problems for non-trivial applications when running in Containers. First, when a Container crashes, kubelet will restart it, but the files will be lost - the Container starts with a clean state. Second, when running Containers together in a Pod it is often necessary to share files between those Containers. The Kubernetes Volume abstraction solves both of these problems.

In this exercise, we shall cover the following operations using K8s
manifests,

<ul class="fa-ul">
  <li><i class="fa-li fa fa-square"></i><b>Create a Deployment without Persistent Volume</b></li>
  <li><i class="fa-li fa fa-square"></i><b>Create a Persistent Volume Claim</b></li>
  <li><i class="fa-li fa fa-square"></i><b>Create a Deployment with Persistent Volume</b></li>
</ul>

<i class="fa fa-info-circle" aria-hidden="true"></i> Will install all the objects to the *default* namespace.

# Persistent Volume

## Create a Deployment without Persistent Volume

**List the deployments in the default namespace.**

``` go-cli
kubectl get deploy
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    No resources found.

Create a new multi-app Deployment by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 06-deploy-svc/01.Service-Discovery.yaml`

{{codebase-file codebase="k8s-workshop" path="code/06-deploy-svc/01.Service-Discovery.yaml" lang="yaml" ref="master" hidden="true"}}

**Verify the output**

    kubectl get deploy,rs,pods

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

```
    NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/jhipapp              1/1     1            1           10s
    deployment.extensions/jhipapp-postgresql   1/1     1            1           10s
    
    NAME                                                  DESIRED   CURRENT   READY   AGE
    replicaset.extensions/jhipapp-54ffccccd5              1         1         1       10s
    replicaset.extensions/jhipapp-postgresql-79bf48fbc8   1         1         1       10s
    
    NAME                                      READY   STATUS    RESTARTS   AGE
    pod/jhipapp-54ffccccd5-jnthr              1/1     Running   0          10s
    pod/jhipapp-postgresql-79bf48fbc8-2pbx2   1/1     Running   0          10s
```    

**Get the app pod reference id from the above command and run the following**

`kubectl port-forward jhipapp-54ffccccd5-vq2k8 8080`

**Verify the output in a browser**

`http://localhost:8080`

The output will be similar to this

![hello-jhipster](../06-deploy-svc/jhip.png)

Log-in with `admin/admin` and make some changes to the app by performing CRUD operations. Changes will be referenced from the postgres `pod/jhipapp-postgresql-79bf48fbc8-ltgkr` backing store.

### <a name="kill">Force Kill</a>

Forcefully kill the postgres pod by running the below command,

`kubectl delete pod/jhipapp-postgresql-79bf48fbc8-2pbx2`

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

```
    NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/jhipapp              1/1     1            1           2m15s
    deployment.extensions/jhipapp-postgresql   1/1     1            1           2m15s
    
    NAME                                                  DESIRED   CURRENT   READY   AGE
    replicaset.extensions/jhipapp-54ffccccd5              1         1         1       2m15s
    replicaset.extensions/jhipapp-postgresql-79bf48fbc8   1         1         1       2m15s
    
    NAME                                      READY   STATUS        RESTARTS   AGE
    pod/jhipapp-54ffccccd5-jnthr              1/1     Running       0          2m15s
    pod/jhipapp-postgresql-79bf48fbc8-2pbx2   1/1     Terminating   0          2m15s
    pod/jhipapp-postgresql-79bf48fbc8-86fpq   1/1     Running       0          5s
```    

Go back to the browser and verify the changes made by refreshing the page. All the changes will be lost. As we killed the pod, all the data persisted in the ephemeral disk of the POD will be wiped out completely.  

> Press Control+C (linux) / Command+C (MacOS) to exit kubectl port-forward

## Create a Deployment with Persistent Volume

eployment by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 09-deploy-volumes/01.PersistentVolume.yaml`

{{codebase-file codebase="k8s-workshop" path="code/09-deploy-volumes/01.PersistentVolume.yaml" lang="yaml" ref="master" hidden="true"}}

**Verify the output**

    kubectl get deploy,rs,pods,pvc

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

```
    NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/jhipapp              1/1     1            1           6m44s
    deployment.extensions/jhipapp-postgresql   1/1     1            1           6m44s
    
    NAME                                                  DESIRED   CURRENT   READY   AGE
    replicaset.extensions/jhipapp-54ffccccd5              0         0         0       6m44s
    replicaset.extensions/jhipapp-b89f9b655               1         1         1       11s
    replicaset.extensions/jhipapp-postgresql-5878d786f8   1         1         1       11s
    replicaset.extensions/jhipapp-postgresql-79bf48fbc8   0         0         0       6m44s
    
    NAME                                      READY   STATUS        RESTARTS   AGE
    pod/jhipapp-54ffccccd5-jnthr              0/1     Terminating   0          6m44s
    pod/jhipapp-b89f9b655-xhhjj               1/1     Running       0          11s
    pod/jhipapp-postgresql-5878d786f8-8xpj2   1/1     Running       0          11s
    pod/jhipapp-postgresql-79bf48fbc8-86fpq   0/1     Terminating   0          4m34s
    
    NAME                                       STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
    persistentvolumeclaim/jhipapp-postgresql   Bound    pvc-bfc240ee-328b-11e9-be21-c260abd2c4fc   1Gi        RWO            standard       45s
```    

**Get the app pod reference id from the above command and run the following**

`kubectl port-forward pod/jhipapp-b89f9b655-xhhjj   8080`

**Verify the output in a browser**

`http://localhost:8080`

The output will be similar to this

![hello-jhipster](../06-deploy-svc/jhip.png)

Log-in with `admin/admin` and make some changes to the app by performing CRUD operations. Changes will be referenced from the postgres `pod/jhipapp-postgresql-79bf48fbc8-ltgkr` backing store.

Now repeat the section [Force Kill](#kill). This time data won't be lost because of the associated persistent volume.

```
    spec:
      volumes:
        - name: data
          persistentVolumeClaim:
            claimName: jhipapp-postgresql
      containers:
        - name: postgres
          image: postgres:10.4
          env:
            - name: POSTGRES_USER
              value: jhipapp
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: jhipapp-postgresql
                  key: postgres-password
          ports:
            - containerPort: 5432
          volumeMounts:
            - name: data
              mountPath: /var/lib/postgresql/
```

Data will be persisted in the PVC volume instead of the ephemeral disk, so that it survives pod restarts/kills.

> Press Control+C (linux) / Command+C (MacOS) to exit kubectl port-forward

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `09-deploy-volumes/_1.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/09-deploy-volumes/_1.clean.sh" lang="bash" ref="master" hidden="true"}}


#Wrap-up
<ul class="fa-ul">
  <li><i class="fa-li fa fa-square"></i><b>Create a Deployment without Persistent Volume</b></li>
  <li><i class="fa-li fa fa-square"></i><b>Create a Persistent Volume Claim</b></li>
  <li><i class="fa-li fa fa-square"></i><b>Create a Deployment with Persistent Volume</b></li>
</ul>
