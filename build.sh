#!/bin/bash

docker buildx rm --force ripe-atlas-alpine
docker buildx create --name ripe-atlas-alpine --use
docker buildx build --no-cache --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64/v8,linux/ppc64le,linux/riscv64,linux/s390x --provenance=mode=max --pull --push --tag ctassisf/ripe-atlas-alpine:latest .
docker buildx rm --force ripe-atlas-alpine
