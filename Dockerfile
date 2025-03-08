# Dockerfile: owntone
# Owntone Docker Image.

LABEL       org.opencontainers.image.source https://github.com/kafouche/owntone

# BUILD STAGE

FROM        ghcr.io/kafouche/alpine:3.21 as buildstage

ARG         RELEASE=28.12

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
                --location "https://github.com/owntone/owntone-server/archive/$RELEASE.tar.gz" \
                --output /tmp/owntone.tar.gz \
            && mkdir --parents /tmp/owntone \
            && tar --directory=/tmp/owntone --extract \
                --file=/tmp/owntone.tar.gz \
                --gzip --strip-components=1

WORKDIR     /tmp/owntone

RUN         autoreconf --install --verbose \
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
            && make DESTDIR=/tmp/owntone/target install \
            && rm -rf \
                /tmp/owntone/target/etc \
                /tmp/owntone/target/var

# RUN STAGE

FROM        ghcr.io/kafouche/alpine:3.21

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

COPY        --from=buildstage /tmp/owntone/target/  /
COPY                          owntone.conf          /etc/

RUN         adduser -D -G users -h /cache -s /sbin/nologin -S owntone \
            && mkdir --parents /cache /media \
            && chmod 644 /etc/owntone.conf

VOLUME      /cache

WORKDIR     /cache

EXPOSE      3689

USER        owntone

ENTRYPOINT  [ "/usr/sbin/owntone" ]
CMD         [ "-f" ]