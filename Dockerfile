FROM ubuntu:trusty

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y exim4

RUN rm -rf /etc/exim4/*
COPY configure.default /etc/exim4/exim4.conf

ENTRYPOINT /usr/sbin/exim4 ${*:--bdf -q30m -v}
