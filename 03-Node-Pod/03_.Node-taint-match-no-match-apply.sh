#!/usr/bin/env sh
pushd $(dirname $0)
envsubst < ./01.Node-taint-match.yaml | kubectl apply -f -
sleep 15
kubectl taint nodes $NODE_NAME runtime=value:NoExecute
popd
