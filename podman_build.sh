#!/bin/bash
mkdir ./build
param=""
if [ "$1" = "--no-cache" ]; then
     param="--no-cache"
fi
podman build $param -t new-lg4ff:latest . -v `pwd`/build:/workdir/build
