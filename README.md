# ripe-atlas-alpine

[![Docker Pulls](https://img.shields.io/docker/pulls/ctassisf/ripe-atlas-alpine)](https://hub.docker.com/r/ctassisf/ripe-atlas-alpine)
[![Docker Image Size](https://img.shields.io/docker/image-size/ctassisf/ripe-atlas-alpine/latest)](https://hub.docker.com/r/ctassisf/ripe-atlas-alpine)
[![GitHub last commit](https://img.shields.io/github/last-commit/CTassisF/ripe-atlas-alpine)](https://github.com/CTassisF/ripe-atlas-alpine/commits/master/)
[![GitHub License](https://img.shields.io/github/license/CTassisF/ripe-atlas-alpine)](https://github.com/CTassisF/ripe-atlas-alpine/blob/master/LICENSE)

Docker images of RIPE Atlas Software Probe using Alpine Linux

**[GitHub](https://github.com/CTassisF/ripe-atlas-alpine) / [Docker Hub](https://hub.docker.com/r/ctassisf/ripe-atlas-alpine)**

Based on the [official code provided by RIPE NCC](https://github.com/RIPE-NCC/ripe-atlas-software-probe), with a few tweaks to make it run under Alpine Linux.

Images are available on Docker Hub for the following architectures:

* 386
* amd64
* arm/v6
* arm/v7
* arm64/v8
* ppc64le
* riscv64
* s390x

## Docker

Pull the latest image:

```bash
docker pull ctassisf/ripe-atlas-alpine:latest
```

Then run the probe:

```bash
docker run --detach \
  --name ripe-atlas \
  --restart unless-stopped \
  --volume ~/ripe-atlas/probe--etc--ripe-atlas:/probe/etc/ripe-atlas \
  --volume ~/ripe-atlas/probe--var--run--ripe-atlas--status:/probe/var/run/ripe-atlas/status \
  --mount type=tmpfs,destination=/probe/var/spool/ripe-atlas/data \
  ctassisf/ripe-atlas-alpine:latest
```

Check if the container is running using `docker ps`, or check its logs using:

```bash
docker logs ripe-atlas
```

The first run will create the directory containing the probe configuration and SSH key.

Use the public SSH key `probe_key.pub` to register your probe here:

https://atlas.ripe.net/apply/swprobe/

## Docker Compose

The following is a minimal `docker-compose.yml` example:

```yaml
services:
  ripe-atlas:
    image: ctassisf/ripe-atlas-alpine:latest
    container_name: ripe-atlas
    restart: unless-stopped
    volumes:
      - ~/ripe-atlas/probe--etc--ripe-atlas:/probe/etc/ripe-atlas
      - ~/ripe-atlas/probe--var--run--ripe-atlas--status:/probe/var/run/ripe-atlas/status
      - type: tmpfs
        target: /probe/var/spool/ripe-atlas/data
```

Start the probe with:

```bash
docker compose up --detach --pull always
```

Check its status and logs with:

```bash
docker compose ps
docker compose logs
```

The configuration and probe status directories are kept outside the container, while the probe's measurement data is stored in a temporary filesystem and is lost when the container is recreated.
