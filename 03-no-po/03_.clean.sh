#!/usr/bin/env sh
kubectl taint nodes $NODE_NAME dedicated:NoSchedule-
kubectl taint nodes $NODE_NAME runtime:NoExecute-
kubectl delete rs spring-music
