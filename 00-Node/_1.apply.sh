#!/usr/bin/env sh
pushd $(dirname $0)
envsubst < ./01.Node-label.yaml | kubectl apply -f -
popd
