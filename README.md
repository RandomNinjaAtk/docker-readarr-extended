# Deprecated

This repository is now deprecated, will no longer be updated and is being archived. 

Scripts/Project has moved to: https://github.com/RandomNinjaAtk/arr-scripts

# [RandomNinjaAtk/readarr-extended](https://github.com/RandomNinjaAtk/docker-readarr-extended)


<img src="https://raw.githubusercontent.com/RandomNinjaAtk/unraid-templates/master/randomninjaatk/img/readarr.png" width="200">


### What is Readarr Extended:

* Linuxserver.io Readarr docker container (develop tag)
* Additional packages and scripts added to the container to provide additional functionality

Readarr itself is not modified in any way, all changes that are pushed to Readarr via public Readarr API's. This is strictly Readarr Develop branch

For more details, visit the [Wiki](https://github.com/RandomNinjaAtk/docker-readarr-extended/wiki)

This containers base image is provided by: [linuxserver/readarr](https://github.com/linuxserver/docker-readarr)


### All Arr-Extended Apps:
* [sabnzbd-extended](https://github.com/RandomNinjaAtk/docker-sabnzbd-extended)
* [lidarr-extended](https://github.com/RandomNinjaAtk/docker-lidarr-extended)
* [radarr-extended](https://github.com/RandomNinjaAtk/docker-radarr-extended)
* [sonarr-extended](https://github.com/RandomNinjaAtk/docker-sonarr-extended)
* [readarr-extended](https://github.com/RandomNinjaAtk/docker-readarr-extended)

## Features
* [Auto Configure Readarr with optimized settings](https://github.com/RandomNinjaAtk/docker-readarr-extended/wiki/AutoConfig.bash)
  * Optimized file/folder naming (based on trash guides)
  * Configures media management settings
  * Configures metadata settings
* [Plex Notify Script](https://github.com/RandomNinjaAtk/docker-readarr-extended/wiki/PlexNotify.bash)
  * Reduce Plex scanning by notifying Plex the exact folder to scan
* [Queue Cleaner Script](https://github.com/RandomNinjaAtk/docker-readarr-extended/wiki/QueueCleaner.bash)
  * Automatically removes downloads that have a "warning" or "failed" status that will not auto-import into Sonarr, which enables Sonarr to automatically re-search for the Title

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
| `-e plexUrl=http://x.x.x.x:32400` | ONLY used if PlexNotify.bash is used...|
| `-e plexToken=` | ONLY used if PlexNotify.bash is used... |

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
  -e plexUrl=http://x.x.x.x:32400 \
  -e plexToken=Token_Goes_Here \
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
      - plexUrl=http://x.x.x.x:32400
      - plexToken=Token_Goes_Here
    ports:
      - 8787:8787
    restart: unless-stopped
```

# Credits
- [LinuxServer.io Team](https://github.com/linuxserver/docker-readarr)
- [Readarr](https://readarr.com/)
- [Docker multi-arch example](https://github.com/ckulka/docker-multi-arch-example)
