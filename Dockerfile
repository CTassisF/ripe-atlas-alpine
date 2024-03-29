FROM alpine:latest AS builder
MAINTAINER CTassisF@users.noreply.github.com
RUN apk add --no-cache autoconf automake g++ gcc git libtool linux-headers make openssl-dev patch sed &&\
 git clone --recursive https://github.com/RIPE-NCC/ripe-atlas-software-probe.git &&\
 sed -i '/fakeroot.*dpkg-deb/Q' ripe-atlas-software-probe/build-config/debian/bin/make-deb &&\
 ./ripe-atlas-software-probe/build-config/debian/bin/make-deb &&\
 mkdir /var/atlasdata

FROM alpine:latest AS atlas
MAINTAINER CTassisF@users.noreply.github.com
COPY --from=builder /atlasswprobe-*-1/usr/local/atlas/ /usr/local/atlas/
COPY --from=builder /ripe-atlas-software-probe/bin/ /usr/local/atlas/bin/
COPY --from=builder /atlasswprobe-*-1/var/atlas-probe/ /var/atlas-probe/
RUN apk add --no-cache libcap net-tools openssh tini &&\
 adduser -D atlas &&\
 ln -s /usr/local/atlas/bin/ATLAS /usr/local/bin/atlas &&\
 echo "CHECK_ATLASDATA_TMPFS=no" > /var/atlas-probe/state/config.txt &&\
 echo "RXTXRPT=yes" >> /var/atlas-probe/state/config.txt &&\
 mkdir /var/atlasdata &&\
 chmod 777 /var/atlasdata &&\
 chown -R atlas: /var/atlas-probe /var/atlasdata &&\
 setcap cap_net_raw=ep /usr/local/atlas/bb-13.3/bin/busybox
WORKDIR /var/atlas-probe
VOLUME ["/var/atlas-probe/etc", "/var/atlas-probe/status"]
ENTRYPOINT ["/sbin/tini", "--"]
CMD rm -rf /var/atlasdata/* 2> /dev/null &&\
 atlas
