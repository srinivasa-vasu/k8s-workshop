#!/usr/bin/env sh
kubectl delete pod spring-music
kubectl delete limitrange cpu-mem-max-min
kubectl delete resourcequota cpu-mem-quota
