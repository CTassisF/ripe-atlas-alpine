FROM alpine:latest AS builder
MAINTAINER CTassisF@users.noreply.github.com
RUN apk add --no-cache autoconf automake g++ gcc git libtool linux-headers make openssl-dev patch sed &&\
 git clone --recursive https://github.com/RIPE-NCC/ripe-atlas-software-probe.git &&\
 cd ripe-atlas-software-probe/ &&\
 autoreconf -iv &&\
 ./configure --prefix=/probe --disable-chown --disable-setcap-install --disable-systemd &&\
 make install

FROM alpine:latest AS probe
MAINTAINER CTassisF@users.noreply.github.com
COPY --from=builder /probe /probe
RUN apk add --no-cache libcap net-tools openssh tini &&\
 adduser -D ripe-atlas &&\
 setcap cap_net_raw=ep /probe/libexec/ripe-atlas/measurement/busybox
WORKDIR /probe
VOLUME ["/probe/etc/ripe-atlas", "/probe/var/run/ripe-atlas/status"]
# "/probe/var/spool/ripe-atlas/data" can also be defined as a volume, but it is optional
ENTRYPOINT ["/sbin/tini", "--"]
CMD [ ! -f /probe/etc/ripe-atlas/config.txt ] && echo "RXTXRPT=yes" > /probe/etc/ripe-atlas/config.txt ;\
 [ ! -f /probe/etc/ripe-atlas/mode ] && echo "prod" > /probe/etc/ripe-atlas/mode ;\
 /probe/sbin/ripe-atlas
