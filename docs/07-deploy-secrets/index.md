---
pageTitle: Underpinning Secrets
---

<md-icon class="fa fa-clock-o fa-lg" aria-hidden="true"></md-icon> Time to complete 30ms

<i class="fa fa-info-circle fa-lg" aria-hidden="true" style="color:dark-blue"></i>
Secrets are secure objects which store sensitive data, such as passwords, OAuth tokens, and SSH keys, in your clusters. Storing sensitive data in Secrets is more secure than plaintext ConfigMaps or in Pod specifications. Using Secrets gives you control over how sensitive data is used, and reduces the risk of exposing the data to unauthorized users.
Sensitive data will be base64 encoded by Secret object. However encryption is also supported.

In this exercise, we shall cover the following operations using K8s
manifests,

<ul class="fa-ul">
  <li><i class="fa-li fa fa-square"></i><b>Externalize sensitive info</b></li>
  <li><i class="fa-li fa fa-square"></i><b>Verify Deployment with externalized Secret</b></li>ata 
</ul>

<i class="fa fa-info-circle" aria-hidden="true"></i> Will install all the objects to the *default* namespace.

# Secret

## Externalize Sensitive Info

**List the deployments in the default namespace.**

``` go-cli
kubectl get deploy
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    No resources found.

Create a new multi-app Deployment by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 07-deploy-secrets/01.Service-Secret.yaml`

{{codebase-file codebase="k8s-workshop" path="code/07-deploy-secrets/01.Service-Secret.yaml" lang="yaml" ref="master" hidden="true"}}

**Verify the output**

    kubectl get deploy,rs,pods,secrets

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this

```
    NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.extensions/jhipapp              1/1     1            1           25s
    deployment.extensions/jhipapp-postgresql   1/1     1            1           25s
    
    NAME                                                  DESIRED   CURRENT   READY   AGE
    replicaset.extensions/jhipapp-57bb86fbf9              1         1         1       25s
    replicaset.extensions/jhipapp-postgresql-846b69457d   1         1         1       25s
    
    NAME                                      READY   STATUS    RESTARTS   AGE
    pod/jhipapp-57bb86fbf9-m8mqj              1/1     Running   0          25s
    pod/jhipapp-postgresql-846b69457d-b84ft   1/1     Running   0          25s
    
    NAME                         TYPE                                  DATA   AGE
    secret/default-token-7b8fm   kubernetes.io/service-account-token   3      13h
    secret/jhipapp-postgresql    Opaque                                1      25s
    secret/jwt-secret            Opaque                                1      25s
```

This time we have created an additional object _Secret_. Will verify the content of the _Secret_ object `secret/jhipapp-postgresql`

**Verify the output in a browser**

`kubectl get secret/jhipapp-postgresql -o yaml`

The output will be similar to this

```
apiVersion: v1
data:
  postgres-password: cmxhMDBqcHA=
kind: Secret
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","data":{"postgres-password":"cmxhMDBqcHA="},"kind":"Secret","metadata":{"annotations":{},"labels":{"app":"jhipapp-postgresql"},"name":"jhipapp-postgresql","namespace":"default"},"type":"Opaque"}
  creationTimestamp: "2019-02-17T06:56:34Z"
  labels:
    app: jhipapp-postgresql
  name: jhipapp-postgresql
  namespace: default
  resourceVersion: "6771"
  selfLink: /api/v1/namespaces/default/secrets/jhipapp-postgresql
  uid: 29db73cd-3281-11e9-be21-c260abd2c4fc
type: Opaque
```

`postgres-password` property is not a plain text. It is encoded and encapsulated in a _Secret_ object.

## Verify Deployment with externalized Secret

If you look into the Deployment manifest of `deployment.extensions/jhipapp-postgresql` and `deployment.extensions/jhipapp`,

_deployment.extensions/jhipapp-postgresql_

```
          env:
            - name: POSTGRES_USER
              value: jhipapp
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: jhipapp-postgresql
                  key: postgres-password
```

_deployment.extensions/jhipapp_

```
            - name: SPRING_DATASOURCE_URL
              value: jdbc:postgresql://jhipapp-postgresql:5432/jhipapp
            - name: SPRING_DATASOURCE_USERNAME
              value: jhipapp
            - name: SPRING_DATASOURCE_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: jhipapp-postgresql
                  key: postgres-password

```

In both the manifests `postgres-password` is referred from the _Secret_ object named _jhipapp-postgresql_. Same as _ConfigMap_, here we have externalized and encoded sensitive info using _Secret_ object and the same is referred in the _Deployment_ manifests..

**Get the pod reference id of the app and run the following**

`kubectl port-forward pod/jhipapp-57bb86fbf9-m8mqj 8080`

**Verify the output in a browser**

`http://localhost:8080`  

Log-in with `admin/admin` and try CRUD operations. Changes will be referenced from the postgres `pod/jhipapp-postgresql-846b69457d-b84ft` backing store same as last time without any issues.

> Press Control+C (linux) / Command+C (MacOS) to exit kubectl port-forward

### Clean-up

Run the script <i class="fa fa-undo" aria-hidden="true" style="color:red"></i> `07-deploy-secrets/_1.clean.sh` to undo the changes

{{codebase-file codebase="k8s-workshop" path="code/07-deploy-secrets/_1.clean.sh" lang="bash" ref="master" hidden="true"}}


#Wrap-up
<ul class="fa-ul">
  <li><i class="fa-li fa fa-square"></i><b>Externalize sensitive info</b></li>
  <li><i class="fa-li fa fa-square"></i><b>Verify Deployment with externalized Secret</b></li>ata 
</ul>
