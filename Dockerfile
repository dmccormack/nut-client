FROM alpine:latest

LABEL maintainer="dmccormack@gmx.net"

ENV UPS_DEVICE=""
ENV UPS_USER=""
ENV UPS_PASSWORD=""

RUN apk --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ add --no-cache nut

COPY src/docker-entrypoint /usr/local/bin/
COPY src/shutdown-cmd /etc/nut/

RUN chmod ug+x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]

WORKDIR /var/run/nut

HEALTHCHECK --start-period=30s --interval=90s --timeout=10s CMD upsc ${UPS_DEVICE} 2>&1 | grep -ci -e error -e stale && exit 1 || exit 0

