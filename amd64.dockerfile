FROM linuxserver/readarr:amd64-develop
LABEL maintainer="RandomNinjaAtk"

ENV TITLE="Readarr Extended"
ENV VERSION="1.0.00001"

RUN \
	echo "************ install and update packages ************" && \
	apk add -U --update --no-cache \
		jq \
		py3-pip && \
	echo "************ install python packages ************" && \
	pip install --upgrade --no-cache-dir -U \
		yq
	
# copy local files
COPY root/ /

# set work directory
WORKDIR /config

# ports and volumes
EXPOSE 8787
VOLUME /config
