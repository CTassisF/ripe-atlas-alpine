# ripe-atlas-alpine
Docker images of RIPE Atlas Software Probe using Alpine Linux

**[GitHub](https://github.com/CTassisF/ripe-atlas-alpine) / [Docker Hub](https://hub.docker.com/r/ctassisf/ripe-atlas-alpine)**

Based on the [official code provided by RIPE NCC](https://github.com/RIPE-NCC/ripe-atlas-software-probe), with a few tweaks to make it run under Alpine Linux.

Images available on Docker Hub for architectures:
- 386
- amd64
- arm/v6
- arm/v7
- arm64/v8
- ppc64le
- riscv64
- s390x

These can be pulled using the `latest` tag:

```
docker pull ctassisf/ripe-atlas-alpine:latest
```

Then you can run:

```
docker run --detach --name ripe-atlas --restart unless-stopped --volume $(pwd)/atlas-probe-etc:/probe/etc/ripe-atlas --volume $(pwd)/atlas-probe-status:/probe/var/run/ripe-atlas/status ctassisf/ripe-atlas-alpine:latest
```

* Check if the container is running using `docker ps`; check container logs using `docker logs ripe-atlas`.

This will create a directory `atlas-probe-etc` with the probe's SSH key in it.

Use the public SSH key `probe_key.pub` to register your probe here: https://atlas.ripe.net/apply/swprobe/
