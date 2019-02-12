#!/usr/bin/env sh
pushd $(dirname $0)
envsubst < ./01.Node-taint-match.yaml | kubectl apply -f -
popd
