#!/usr/bin/env sh
pushd $(dirname $0)
envsubst < ./02.Node-taint-no-match.yaml | kubectl apply -f -
popd
