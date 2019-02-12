#!/usr/bin/env sh
kubectl delete pod spring-music
kubectl label node $NODE_NAME role-
