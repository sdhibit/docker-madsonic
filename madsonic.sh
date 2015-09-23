#!/bin/sh

#create folders on config
mkdir -p /config/media/incoming
mkdir -p /config/media/podcast
mkdir -p /config/playlists/import
mkdir -p /config/playlists/export
mkdir -p /config/playlists/backup
mkdir -p /config/transcode

#copy transcode to config directory - transcode directory is subdir of path set from --home flag, do not alter
#cp /var/madsonic/transcode/* /config/transcode/



if [ -z "$CONTEXT" ]; then
  CONTEXT=/
fi

if [ "$SSL" = "yes" ]; then
  PORTS="--https-port=4050"
else
  PORTS="--port=4040"
fi

# Latest version of Madsonic 6.0 has invalid carriage returns
sed -i -e 's/\r$//' /var/madsonic/madsonic.sh

/var/madsonic/madsonic.sh \
  --home=/config \
  --context-path=$CONTEXT \
  --default-music-folder=/media \
  --default-podcast-folder=/config/media/podcast \
  --default-playlist-import-folder=/config/playlists/import \
  --default-playlist-export-folder=/config/playlists/export \
  --default-playlist-backup-folder=/config/playlists/backup \
  ${PORTS}

