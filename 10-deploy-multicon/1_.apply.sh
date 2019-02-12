#!/usr/bin/env sh
pushd $(dirname $0)
envsubst < ./01.Multi-sidecar-container.yaml | kubectl apply -f -
popd
