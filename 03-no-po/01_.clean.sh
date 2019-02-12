#!/usr/bin/env sh
kubectl taint nodes $NODE_NAME dedicated:NoSchedule-
kubectl delete rs spring-music
