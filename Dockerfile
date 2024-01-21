# BUILD STAGE

FROM        debian:bullseye-slim as buildstage

ARG         DAAPD_RELEASE

RUN         printf '# Install build packages.\n' \
            && apt update -qq \
            && apt full-upgrade -qq --yes \
            && apt install --no-install-recommends -qq --yes \
                ca-certificates \
                curl \
            && apt install --no-install-recommends -qq --yes \
                build-essential \
                autotools-dev \
                autoconf \
                automake \
                libtool \
                gettext \
                gawk \
                gperf \
                bison \
                flex \
                libconfuse-dev \
                libunistring-dev \
                libsqlite3-dev \
                libavcodec-dev \
                libavformat-dev \
                libavfilter-dev \
                libswscale-dev \
                libavutil-dev \
                libasound2-dev \
                libmxml-dev \
                libgcrypt20-dev \
                libavahi-client-dev \
                zlib1g-dev \
                libevent-dev \
                libplist-dev \
                libsodium-dev \
                libjson-c-dev \
                libwebsockets-dev \
                libcurl4-openssl-dev \
                libprotobuf-c-dev \
                libgnutls*-dev \
            && if [ -z "${DAAPD_RELEASE}" ]; then \
                DAAPD_RELEASE="$(curl --silent --request GET \
                    "https://api.github.com/repos/owntone/owntone-server/releases/latest" \
                    | awk '/tag_name/{print $4;exit}' FS='[""]')"; \
            fi \
            && curl \
                --location "https://github.com/owntone/owntone-server/archive/${DAAPD_RELEASE}.tar.gz" \
                --output /tmp/owntone-server.tar.gz \
            && mkdir --parents /tmp/owntone-server \
            && tar --directory=/tmp/owntone-server --extract --file=/tmp/owntone-server.tar.gz --gzip --strip-components=1

WORKDIR     /tmp/owntone-server

RUN         printf '# Build OwnTone Server.\n' \
            && autoreconf --install --verbose \
            && ./configure \
                --infodir=/usr/share/info \
                --localstatedir=/var \
                --mandir=/usr/share/man \
                --sysconfdir=/etc \
                --prefix=/usr \
                --disable-install_systemd \
                --enable-chromecast \
                --enable-itunes \
                --enable-lastfm \
                --enable-mpd \
                --enable-spotify \
            && make \
            && make DESTDIR=/tmp/owntone install \
            && rm --recursive --force \
                /tmp/owntone/config \
                /tmp/owntone/var

# RUN STAGE

FROM        debian:bullseye-slim

RUN         printf '# Install run packages.\n' \
            && apt update -qq \
            && apt full-upgrade -qq --yes \
            && apt install --no-install-recommends -qq --yes \
                avahi-daemon \
                libantlr3c-3.4-0 \
                libasound2 \
                libavahi-client3 \
                libavahi-common3 \
                libavcodec58 \
                libavfilter7 \
                libavformat58 \
                libavutil56 \
                libc6 \
                libconfuse2 \
                libcurl3-gnutls \
                libcurl4 \
                libevent-2.1-7 \
                libevent-pthreads-2.1-7 \
                libgcrypt20 \
                libgnutls30 \
                libgpg-error0 \
                libjson-c5 \
                libmxml1 \
                libplist3 \
                libprotobuf-c1 \
                libsodium23 \
                libsqlite3-0 \
                libswscale5 \
                libunistring2 \
                libwebsockets16 \
                lsb-base \
                psmisc \
                zlib1g \
            && mkdir --parents /cache /music /var/cache/owntone

COPY        --from=buildstage       /tmp/owntone/           /
COPY                                docker-entrypoint.sh    /

ENV         GENERAL_UID=owntone \
            GENERAL_DB_PATH=/cache/songs.db3 \
            GENERAL_DB_BACKUP_PATH=/cache/songs.bak \
            GENERAL_LOGFILE=/var/log/owntone.log \
            GENERAL_LOGLEVEL=log \
            GENERAL_ADMIN_PASSWORD= \
            GENERAL_WEBSOCKET_PORT=3688 \
            GENERAL_WEBSOCKET_INTERFACE= \
            GENERAL_TRUSTED_NETWORKS= \
            GENERAL_IPV6=yes \
            GENERAL_BIND_ADDRESS= \
            GENERAL_CACHE_PATH= \
            GENERAL_CACHE_DAAP_THRESHOLD= \
            GENERAL_SPEAKER_AUTOSELECT= \
            GENERAL_HIGH_RESOLUTION_CLOCK= \
            LIBRARY_NAME=%h \
            LIBRARY_PORT=3689 \
            LIBRARY_PASSWORD= \
            LIBRARY_FOLLOW_SYMLINKS= \
            LIBRARY_COMPILATION_ARTIST= \
            LIBRARY_HIDE_SINGLES= \
            LIBRARY_RADIO_PLAYLISTS= \
            LIBRARY_NAME_LIBRARY= \
            LIBRARY_NAME_MUSIC= \
            LIBRARY_NAME_MOVIES= \
            LIBRARY_NAME_TVSHOWS= \
            LIBRARY_NAME_PODCASTS= \
            LIBRARY_NAME_AUDIOBOOKS= \
            LIBRARY_NAME_RADIO= \
            LIBRARY_ARTWORK_INDIVIDUAL= \
            LIBRARY_FILESCAN_DISABLE= \
            LIBRARY_ONLY_FIRST_GENRE= \
            LIBRARY_M3U_OVERRIDES= \
            LIBRARY_ITUNES_OVERRIDE= \
            LIBRARY_ITUNES_SMARTPL= \
            LIBRARY_PIPE_AUTOSTART= \
            LIBRARY_RATING_UPDATES= \
            LIBRARY_ALLOW_MODIFYING_STORED_PLAYLISTS= \
            LIBRARY_DEFAULT_PLAYLIST_DIRECTORY= \
            LIBRARY_CLEAR_QUEUE_ON_STOP_DISABLE= \
            AUDIO_NICKNAME=Computer \
            AUDIO_TYPE= \
            AUDIO_SERVER= \
            AUDIO_CARD= \
            AUDIO_MIXER= \
            AUDIO_MIXER_DEVICE= \
            AUDIO_SYNC_DISABLE= \
            AUDIO_OFFSET_MS= \
            AUDIO_ADJUST_PERIOD_SECONDS= \
            ALSA_CARD_NAME= \
            ALSA_NICKNAME= \
            ALSA_MIXER= \
            ALSA_MIXER_DEVICE= \
            FIFO_NICKNAME= \
            FIFO_PATH= \
            AIRPLAY_SHARED_CONTROL_PORT= \
            AIRPLAY_SHARED_TIMING_PORT= \
            AIRPLAY_MAX_VOLUME= \
            AIRPLAY_EXCLUDE= \
            AIRPLAY_PERMANENT= \
            AIRPLAY_RECONNECT= \
            AIRPLAY_PASSWORD= \
            AIRPLAY_RAOP_DISABLE= \
            AIRPLAY_NICKNAME= \
            CHROMECAST_MAX_VOLUME= \
            CHROMECAST_EXCLUDE= \
            CHROMECAST_NICKNAME= \
            SPOTIFY_BITRATE= \
            SPOTIFY_BASE_PLAYLIST_DISABLE= \
            SPOTIFY_ARTIST_OVERRIDE= \
            SPOTIFY_ALBUM_OVERRIDE= \
            RCP_EXCLUDE= \
            RCP_CLEAR_ON_CLOSE= \
            MPD_PORT= \
            MPD_HTTP_PORT= \
            SQLITE_PRAGMA_CACHE_SIZE_LIBRARY= \
            SQLITE_PRAGMA_CACHE_SIZE_CACHE= \
            SQLITE_PRAGMA_JOURNAL_MODE= \
            SQLITE_PRAGMA_SYNCHRONOUS= \
            SQLITE_PRAGMA_MMAP_SIZE_LIBRARY= \
            SQLITE_PRAGMA_MMAP_SIZE_CACHE= \
            SQLITE_VACUUM= \
            STREAMING_SAMPLE_RATE= \
            STREAMING_BIT_RATE=

EXPOSE      3689

VOLUME      /cache \
            /music

WORKDIR     /cache

ENTRYPOINT  [ "/docker-entrypoint.sh" ]
