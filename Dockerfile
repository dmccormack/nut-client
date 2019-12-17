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

