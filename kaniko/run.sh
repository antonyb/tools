#!/bin/sh

docker run --rm gcr.io/kaniko-project/executor:v1.6.0-debug version

docker run --rm -v `pwd`:/workspace gcr.io/kaniko-project/executor:v1.6.0-debug --no-push -v debug