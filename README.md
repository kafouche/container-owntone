# Owntone

This image is based on *Alpine Linux* latest stable image.

This image comes without the folllowing features:
- ChromeCast
- Spotify
- MPD
- Web User Interface
- ...

## Ports

| Port   | Description              |
|--------|--------------------------|
| `3689` | Default Port.            |

## Volumes

| Volume   | Description              |
|----------|--------------------------|
| `/cache` | Configuration Directory. |
| `/media` | Music and Media Files.   |

## Run

The following `code blocks` are only there as **examples**.

### Manual

```
docker run --detach \
    --mount type=bind,src=$(pwd)/cache,dst=/cache \
    --mount type=bind,src=$(pwd)/media,dst=/media,readonly=true \
    --mount type=bind,src=/var/run/dbus,dst=/var/run/dbus,readonly=true \
    --mount type=bind,src=/var/run/avahi-daemon/socket,dst=/var/run/avahi-daemon/socket,readonly=true \
    --name owntone \
    --network bridge \
    --publish 3689:3689 \
    --restart unless-stopped \
    ghcr.io/kafouche/owntone:latest
```

### Composer
```
---
version: "3"

services:
  owntone:
    container_name: "owntone"
    image: "ghcr.io/kafouche/owntone:latest"
    network_mode: bridge
    ports:
      - 3689:3689
    restart: unless-stopped
    volumes:
      - type: bind
        read_only: true
        source: "/var/run/dbus"
        target: "/var/run/dbus"
      - type: bind
        read_only: true
        source: "/var/run/avahi-daemon/socket"
        target: "/var/run/avahi-daemon/socket"
      - type: bind
        source: "./cache/"
        target: "/cache/"
      - type: bind
        read_only: true
        source: "/path/to/media/"
        target: "/media/"
```

## Build

**Docker**

```
docker build -t ghcr.io/kafouche/owntone:latest .
```

**Podman**

```
podman build -t ghcr.io/kafouche/owntone:latest .
```
