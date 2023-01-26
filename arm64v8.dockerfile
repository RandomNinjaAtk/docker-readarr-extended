FROM alpine AS builder

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM linuxserver/readarr:arm64v8-develop

# Add QEMU
COPY --from=builder qemu-aarch64-static /usr/bin

LABEL maintainer="RandomNinjaAtk"

ENV TITLE="Readarr Extended"
ENV VERSION="1.0.00001"

RUN \
	echo "************ install and update packages ************" && \
	apk add -U --update --no-cache \
		jq \
		ffmpeg
	
# copy local files
COPY root/ /

# set work directory
WORKDIR /config

# ports and volumes
EXPOSE 8787
VOLUME /config
