#!/bin/bash

set -o errexit

set_value() {
    local key="${1}"
    local value="${2}"

    if [ ! -z "$key" ] && [ ! -z "$value" ]; then
        if [[ "$value" =~ yes|no|true|false|log|\d+ ]]; then
            printf '    %s = %s\n' "$key" "$value" >> /etc/owntone.conf
        else
            printf '    %s = "%s"\n' "$key" "$value" >> /etc/owntone.conf
        fi
    fi
}

printf 'general {\n' > /etc/owntone.conf
printf '\n' >> /etc/owntone.conf

set_value 'uid'                                 "$GENERAL_UID"
set_value 'db_path'                             "$GENERAL_DB_PATH"
set_value 'db_backup_path'                      "$GENERAL_DB_BACKUP_PATH"
set_value 'logfile'                             "$GENERAL_LOGFILE"
set_value 'loglevel'                            "$GENERAL_LOGLEVEL"
set_value 'admin_password'                      "$GENERAL_ADMIN_PASSWORD"
set_value 'websocket_port'                      "$GENERAL_WEBSOCKET_PORT"
set_value 'websocket_interface'                 "$GENERAL_WEBSOCKET_INTERFACE"
set_value 'trusted_networks'                    "$GENERAL_TRUSTED_NETWORKS"
set_value 'ipv6'                                "$GENERAL_IPV6"
set_value 'bind_address'                        "$GENERAL_BIND_ADDRESS"
set_value 'cache_path'                          "$GENERAL_CACHE_PATH"
set_value 'cache_daap_threshold'                "$GENERAL_CACHE_DAAP_THRESHOLD"
set_value 'speaker_autoselect'                  "$GENERAL_SPEAKER_AUTOSELECT"
set_value 'high_resolution_clock'               "$GENERAL_HIGH_RESOLUTION_CLOCK"

printf '\n' >> /etc/owntone.conf
printf '}\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf
printf 'library {\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf

set_value 'name'                                "$LIBRARY_NAME"
set_value 'port'                                "$LIBRARY_PORT"
set_value 'password'                            "$LIBRARY_PASSWORD"

printf '    directories = { "/music" }\n' >> /etc/owntone.conf

set_value 'follow_symlinks'                     "$LIBRARY_FOLLOW_SYMLINKS"

printf '    podcasts = { "/Podcasts" }\n' >> /etc/owntone.conf
printf '    audiobooks = { "/Audiobooks" }\n' >> /etc/owntone.conf
printf '    compilations = { "/Compilations" }\n' >> /etc/owntone.conf

set_value 'compilation_artist'                  "$LIBRARY_COMPILATION_ARTIST"
set_value 'hide_singles'                        "$LIBRARY_HIDE_SINGLES"
set_value 'radio_playlists'                     "$LIBRARY_RADIO_PLAYLISTS"
set_value 'name_library'                        "$LIBRARY_NAME_LIBRARY"
set_value 'name_music'                          "$LIBRARY_NAME_MUSIC"
set_value 'name_movies'                         "$LIBRARY_NAME_MOVIES"
set_value 'name_tvshows'                        "$LIBRARY_NAME_TVSHOWS"
set_value 'name_podcasts'                       "$LIBRARY_NAME_PODCASTS"
set_value 'name_audiobooks'                     "$LIBRARY_NAME_AUDIOBOOKS"
set_value 'name_radio'                          "$LIBRARY_NAME_RADIO"

#printf '    artwork_basenames = { "artwork", "cover", "Folder" }\n' >> /etc/owntone.conf

set_value 'artwork_individual'                  "$LIBRARY_ARTWORK_INDIVIDUAL"

#printf '    filetypes_ignore = { ".db", ".ini", ".db-journal", ".pdf", ".metadata" }\n' >> /etc/owntone.conf
#printf '    filepath_ignore = { "myregex" }\n' >> /etc/owntone.conf

set_value 'filescan_disable'                    "$LIBRARY_FILESCAN_DISABLE"
set_value 'only_first_genre'                    "$LIBRARY_ONLY_FIRST_GENRE"
set_value 'm3u_overrides'                       "$LIBRARY_M3U_OVERRIDES"
set_value 'itunes_overrides'                    "$LIBRARY_ITUNES_OVERRIDE"
set_value 'itunes_smartpl'                      "$LIBRARY_ITUNES_SMARTPL"

#printf '    no_decode = { "format", "format" }\n' >> /etc/owntone.conf
#printf '    force_decode = { "format", "format" }\n' >> /etc/owntone.conf
#printf '    decode_audio_filters = { }\n' >> /etc/owntone.conf

set_value 'pipe_autostart'                      "$LIBRARY_PIPE_AUTOSTART"
set_value 'rating_updates'                      "$LIBRARY_RATING_UPDATES"
set_value 'allow_modifying_stored_playlists'    "$LIBRARY_ALLOW_MODIFYING_STORED_PLAYLISTS"
set_value 'default_playlist_directory'          "$LIBRARY_DEFAULT_PLAYLIST_DIRECTORY"
set_value 'clear_queue_on_stop_disable'         "$LIBRARY_CLEAR_QUEUE_ON_STOP_DISABLE"

printf '\n' >> /etc/owntone.conf
printf '}\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf
printf 'audio {\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf

set_value 'nickname'                            "$AUDIO_NICKNAME"
set_value 'type'                                "$AUDIO_TYPE"
set_value 'server'                              "$AUDIO_SERVER"
set_value 'card'                                "$AUDIO_CARD"
set_value 'mixer'                               "$AUDIO_MIXER"
set_value 'mixer_device'                        "$AUDIO_MIXER_DEVICE"
set_value 'sync_disable'                        "$AUDIO_SYNC_DISABLE"
set_value 'offset_ms'                           "$AUDIO_OFFSET_MS"
set_value 'adjust_period_seconds'               "$AUDIO_ADJUST_PERIOD_SECONDS"

printf '\n' >> /etc/owntone.conf
printf '}\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf

if [ ! -z "$ALSA_CARD_NAME" ]; then
    printf 'alsa "%s" {\n' "$ALSA_CARD_NAME" >> /etc/owntone.conf
    printf '\n' >> /etc/owntone.conf
    printf 'alsa {\n' >> /etc/owntone.conf
    printf '\n' >> /etc/owntone.conf

    set_value 'nickname'                        "$ALSA_NICKNAME"
    set_value 'mixer'                           "$ALSA_MIXER"
    set_value 'mixer_device'                    "$ALSA_MIXER_DEVICE"

    printf '\n' >> /etc/owntone.conf
    printf '}\n' >> /etc/owntone.conf
    printf '\n' >> /etc/owntone.conf
    printf '\n' >> /etc/owntone.conf
fi

printf 'fifo {\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf

set_value 'nickname'                            "$FIFO_NICKNAME"
set_value 'path'                                "$FIFO_PATH"

printf '\n' >> /etc/owntone.conf
printf '}\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf
printf 'airplay_shared {\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf

set_value 'control_port'                        "$AIRPLAY_SHARED_CONTROL_PORT"
set_value 'timing_port'                         "$AIRPLAY_SHARED_TIMING_PORT"

printf '\n' >> /etc/owntone.conf
printf '}\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf


if [ ! -z "$AIRPLAY_DEVICE" ]; then
    printf 'airplay "%s" {\n' "$AIRPLAY_DEVICE" >> /etc/owntone.conf
    printf '\n' >> /etc/owntone.conf

    set_value 'max_volume'                      "$AIRPLAY_MAX_VOLUME"
    set_value 'exclude'                         "$AIRPLAY_EXCLUDE"
    set_value 'permanent'                       "$AIRPLAY_PERMANENT"
    set_value 'reconnect'                       "$AIRPLAY_RECONNECT"
    set_value 'password'                        "$AIRPLAY_PASSWORD"
    set_value 'raop_disable'                    "$AIRPLAY_RAOP_DISABLE"
    set_value 'nickname'                        "$AIRPLAY_NICKNAME"

    printf '\n' >> /etc/owntone.conf
    printf '}\n' >> /etc/owntone.conf
    printf '\n' >> /etc/owntone.conf
    printf '\n' >> /etc/owntone.conf
fi

if [ ! -z "$CHROMECAST_DEVICE" ]; then
    printf 'chromecast "%s" {\n' "$CHROMECAST_DEVICE" >> /etc/owntone.conf
    printf '\n' >> /etc/owntone.conf

    set_value 'max_volume'                      "$CHROMECAST_MAX_VOLUME"
    set_value 'exclude'                         "$CHROMECAST_EXCLUDE"
    set_value 'nickname'                        "$CHROMECAST_NICKNAME"

    printf '\n' >> /etc/owntone.conf
    printf '}\n' >> /etc/owntone.conf
    printf '\n' >> /etc/owntone.conf
    printf '\n' >> /etc/owntone.conf
fi

printf 'spotify {\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf

set_value 'bitrate'                             "$SPOTIFY_BITRATE"
set_value 'base_playlist_disable'               "$SPOTIFY_BASE_PLAYLIST_DISABLE"
set_value 'artist_override'                     "$SPOTIFY_ARTIST_OVERRIDE"
set_value 'album_override'                      "$SPOTIFY_ALBUM_OVERRIDE"

printf '\n' >> /etc/owntone.conf
printf '}\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf

if [ ! -z "$RCP_DEVICE" ]; then
    printf 'rcp "%s" {\n' "$RCP_DEVICE" >> /etc/owntone.conf
    printf '\n' >> /etc/owntone.conf

    set_value 'exclude'                         "$RCP_EXCLUDE"
    set_value 'clear_on_close'                  "$RCP_CLEAR_ON_CLOSE"

    printf '\n' >> /etc/owntone.conf
    printf '}\n' >> /etc/owntone.conf
    printf '\n' >> /etc/owntone.conf
    printf '\n' >> /etc/owntone.conf
fi

printf 'mpd {\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf

set_value 'port'                                "$MPD_PORT"
set_value 'http_port'                           "$MPD_HTTP_PORT"

printf '\n' >> /etc/owntone.conf
printf '}\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf
printf 'sqlite {\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf

set_value 'pragma_cache_size_library'           "$SQLITE_PRAGMA_CACHE_SIZE_LIBRARY"
set_value 'pragma_cache_size_cache'             "$SQLITE_PRAGMA_CACHE_SIZE_CACHE"
set_value 'pragma_journal_mode'                 "$SQLITE_PRAGMA_JOURNAL_MODE"
set_value 'pragma_synchronous'                  "$SQLITE_PRAGMA_SYNCHRONOUS"
set_value 'pragma_mmap_size_library'            "$SQLITE_PRAGMA_MMAP_SIZE_LIBRARY"
set_value 'pragma_mmap_size_cache'              "$SQLITE_PRAGMA_MMAP_SIZE_CACHE"
set_value 'vacuum'                              "$SQLITE_VACUUM"

printf '\n' >> /etc/owntone.conf
printf '}\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf
printf 'streaming {\n' >> /etc/owntone.conf
printf '\n' >> /etc/owntone.conf

set_value 'sample_rate'                         "$STREAMING_SAMPLE_RATE"
set_value 'bit_rate'                            "$STREAMING_BIT_RATE"

printf '\n' >> /etc/owntone.conf
printf '}\n' >> /etc/owntone.conf

owntone -f
