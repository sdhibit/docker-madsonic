#!/bin/sh

#create folders on config
mkdir -p /config/media/incoming
mkdir -p /config/media/podcast
mkdir -p /config/playlists/import
mkdir -p /config/playlists/export
mkdir -p /config/playlists/backup
mkdir -p /config/transcode

#copy transcode to config directory - transcode directory is subdir of path set from --home flag, do not alter
cp /var/madsonic/transcode/linux/* /config/transcode/

if [ -z "$CONTEXT" ]; then
  CONTEXT=/
fi

if [ "$SSL" = "yes" ]; then
  PORTS="--https-port=4050"
else
  PORTS="--port=4040"
fi

/var/madsonic/madsonic.sh \
  --home=/config \
  --context-path=$CONTEXT \
  --default-music-folder=/media \
  --default-podcast-folder=/config/media/podcast \
  --default-playlist-import-folder=/config/playlists/import \
  --default-playlist-export-folder=/config/playlists/export \
  --default-playlist-backup-folder=/config/playlists/backup \
  ${PORTS}

