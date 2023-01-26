# [RandomNinjaAtk/readarr-extended](https://github.com/RandomNinjaAtk/docker-readarr-extended)
[![Docker Build](https://img.shields.io/docker/cloud/automated/randomninjaatk/readarr-extended?style=flat-square)](https://hub.docker.com/r/randomninjaatk/readarr-extended)
[![Docker Pulls](https://img.shields.io/docker/pulls/randomninjaatk/readarr-extended?style=flat-square)](https://hub.docker.com/r/randomninjaatk/readarr-extended)
[![Docker Stars](https://img.shields.io/docker/stars/randomninjaatk/readarr-extended?style=flat-square)](https://hub.docker.com/r/randomninjaatk/readarr-extended)
[![Docker Hub](https://img.shields.io/badge/Open%20On-DockerHub-blue?style=flat-square)](https://hub.docker.com/r/randomninjaatk/readarr-extended)

<img src="https://raw.githubusercontent.com/RandomNinjaAtk/unraid-templates/master/randomninjaatk/img/readarr.png" width="200">


### What is Readarr Extended:

* Linuxserver.io Readarr docker container (develop tag)
* Additional packages and scripts added to the container to provide additional functionality

Readarr itself is not modified in any way, all changes that are pushed to Readarr via public Readarr API's. This is strictly Readarr Develop branch

For more details, visit the [Wiki](https://github.com/RandomNinjaAtk/docker-readarr-extended/wiki)

This containers base image is provided by: [linuxserver/readarr](https://github.com/linuxserver/docker-readarr)

## Supported Architectures

The architectures supported by this image are:

| Architecture | Available | Tag |
| :----: | :----: | ---- |
| multi | ✅ | latest |
| x86-64 | ✅ | amd64 |
| arm64v8 | ✅ | arm64v8 |
| arm32v7 | ✅ | arm32v7 |

## Version Tags

| Tag | Description |
| :----: | --- |
| latest | Readarr (develop) + Extended Scripts |

## Application Setup

Access the webui at `<your-ip>:8787`, for more information check out [Readarr](https://readarr.com/).

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| --- | --- |
| `-p 8787` | The port for the Readarr webinterface |
| `-v /config` | Configuration files for Readarr. (<strong>required path</strong>)|
| `-e enableAutoConfig=true` | true = enabled :: Enables AutoConfig script to run after startup |
| `-e enableQueueCleaner=true` | true = enabled :: Enables QueueCleaner Script that automatically removes stuck downloads that cannot be automatically imported on a 15 minute interval |

## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=readarr-extended \
  -v /path/to/config/files:/config \
  -p 8787:8787 \
  -e TZ=America/New_York \
  -e PUID=1000 \
  -e PGID=1000 \
  -e enableAutoConfig=true \
  -e enableQueueCleaner=true \
  randomninjaatk/readarr-extended:latest
```


### docker-compose

Compatible with docker-compose v2 schemas.

```
version: "2.1"
services:
  readarr-extended:
    image: randomninjaatk/readarr-extended:latest
    container_name: readarr-extended
    volumes:
      - /path/to/config/files:/config
    environment:
      - TZ=America/New_York
      - PUID=1000
      - PGID=1000
      - enableAutoConfig=true
      - enableQueueCleaner=true
    ports:
      - 8787:8787
    restart: unless-stopped
```

# Credits
- [LinuxServer.io Team](https://github.com/linuxserver/docker-readarr)
- [Readarr](https://readarr.com/)
- [Docker multi-arch example](https://github.com/ckulka/docker-multi-arch-example)
