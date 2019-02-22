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

**List the deployments in the default namespace**

``` go-cli
kubectl get resourcequota
```

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,

    No resources found.

Create a new ResourceQuota by running the manifest <i class="fa fa-check-circle" aria-hidden="true" style="color:green"></i> `kubectl apply -f 11-quotas/01.ResourceQuota.yaml`

{{codebase-file codebase="k8s-workshop" path="code/11-quotas/01.ResourceQuota.yaml" lang="yaml" ref="master" hidden="true"}}



# Wrap-up
<ul class="fa-ul">
  <li><i class="fa-li fa fa-check-square"></i><b>Resource Quota</b></li>
  <li><i class="fa-li fa fa-check-square"></i><b>Limit Range</b></li>
</ul>
