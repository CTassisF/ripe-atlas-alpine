#!/bin/bash

docker build -f Dockerfile.amd64 -t ctassisf/ripe-atlas-alpine:amd64 .
docker build -f Dockerfile.arm32v7 -t ctassisf/ripe-atlas-alpine:arm32v7 .
docker build -f Dockerfile.arm64v8 -t ctassisf/ripe-atlas-alpine:arm64v8 .

