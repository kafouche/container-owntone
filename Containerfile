# Dockerfile: owntone
# Kafouche OwnTone Server Image (source).

ARG         RELEASE=28.12

ARG         SOURCE_URL=https://github.com/owntone/owntone-server/archive/$RELEASE.tar.gz

ARG         SOURCE_DIR=/tmp/source

ARG         SOURCE_TAR=/tmp/archive.tar.gz

ARG         TARGET_DIR=/tmp/target


# BUILD STAGE

FROM        ghcr.io/kafouche/alpine:latest as buildstage

ARG         SOURCE_URL \
            SOURCE_DIR \
            SOURCE_TAR \
            TARGET_DIR

# `--enable-chromecast` depends on `libgnutls*-dev`
# `--with-pulseaudio` depends on `libpulse-dev`
# `--enable-spotify` depends on `libprotobuf-c-dev`
# `--enable-webinterface` depends on `libwebsockets-dev`
# `--with-libwebsockets` depends on `libwebsockets-dev`

RUN         apk --no-cache --update upgrade \
            && apk --no-cache --update add \
              alsa-lib-dev \
              autoconf \
              automake \
              avahi-dev \
              bison \
              confuse-dev \
              curl-dev \
              flex \
              ffmpeg-dev \
              g++ \
              gawk \
              gettext \
              gettext-dev \
              gperf \
              json-c-dev \
              libevent-dev \
              libgcrypt-dev \
              libplist-dev \
              libsodium-dev \
              libtool \
              libunistring-dev \
              libwebsockets-dev \
              libxml2-dev \
              make \
              protobuf-c-dev \
              sqlite-dev \
              zlib-dev

RUN         apk --no-cache --update add \
              curl \
            && curl \
              --location "${SOURCE_URL}" \
              --output "${SOURCE_TAR}" \
            && mkdir --parents "${SOURCE_DIR}" \
            && tar \
              --directory="${SOURCE_DIR}" \
              --extract \
              --file="${SOURCE_TAR}" \
              --gzip \
              --strip-components=1

WORKDIR     "${SOURCE_DIR}"

RUN         autoreconf \
              --force \
              --include=/usr/share/gettext/m4 \
              --install \
              --verbose \
            && ./configure \
              --infodir=/usr/share/info \
              --localstatedir=/var \
              --mandir=/usr/share/man \
              --sysconfdir=/etc \
              --prefix=/usr \
              --disable-install_systemd \
              --disable-lastfm \
              --disable-mpd \
              --disable-spotify \
              --disable-webinterface \
              --disable-libwebsockets \
              --enable-itunes \
            && make \
            && make check \
            && make DESTDIR="${TARGET_DIR}" install \
            && rm -rf \
              "${TARGET_DIR}/etc" \
              "${TARGET_DIR}/var"

# RUN STAGE

FROM        ghcr.io/kafouche/alpine:latest

LABEL       org.opencontainers.image.authors="kafouche"
LABEL       org.opencontainers.image.base.name="ghcr.io/kafouche/owntone:28.12"
LABEL       org.opencontainers.image.ref.name="ghcr.io/kafouche/alpine"
LABEL       org.opencontainers.image.source="https://github.com/kafouche/container-owntone"
LABEL       org.opencontainers.image.title="OwnTone"
LABEL       org.opencontainers.image.version="28.12"
LABEL       image.tags[0]="ghcr.io/kafouche/owntone:latest-src"
LABEL       image.tags[1]="ghcr.io/kafouche/owntone:latest"

# ------------------------------------------------------------------------------

ARG         TARGET_DIR

RUN         apk --no-cache --update upgrade \
            && apk --no-cache --update add \
              avahi \
              confuse \
              dbus \
              ffmpeg \
              json-c \
              libcurl \
              libevent \
              libgcrypt \
              libplist \
              libsodium \
              libunistring \
              libuuid \
              libwebsockets \
              libxml2 \
              sqlite \
              sqlite-libs

RUN         mkdir --parents /var/cache/owntone /srv/music

COPY        --from=buildstage "${TARGET_DIR}/" /
COPY        owntone.conf /etc/

RUN         addgroup -S owntone \
            && adduser -D -G owntone -h /var/cache/owntone -H -s /sbin/nologin -S owntone \
            && chown -R owntone:owntone /var/cache/owntone/ \
            && chmod 644 /etc/owntone.conf

VOLUME      /var/cache/owntone

WORKDIR     /var/cache/owntone

EXPOSE      3689

USER        owntone

ENTRYPOINT  [ "/usr/sbin/owntone" ]
CMD         [ "-f" ]
