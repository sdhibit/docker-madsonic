#!/bin/sh

#create folders on config
mkdir -p /config/media/incoming
mkdir -p /config/media/podcast
mkdir -p /config/playlists/import
mkdir -p /config/playlists/export
mkdir -p /config/playlists/backup
mkdir -p /config/transcode

#copy transcode to config directory - transcode directory is subdir of path set from --home flag, do not alter
cp /var/madsonic/transcode/transcode/* /config/transcode/
chmod +x /config/transcode/*

# Force Madsonic to run in foreground
sed -i 's/-jar madsonic-booter.jar > \${LOG} 2>\&1 \&/-jar madsonic-booter.jar/g' /var/madsonic/madsonic.sh

if [ -z "$CONTEXT" ]; then
  CONTEXT=/
fi

if [ "$SSL" = "yes" ]; then
  PORTS="--https-port=4050"
else
  PORTS="--port=4040"
fi

/sbin/su-exec madsonic /var/madsonic/madsonic.sh \
  --home=/config \
  --context-path=$CONTEXT \
  --default-music-folder=/media \
  --default-podcast-folder=/config/media/podcast \
  --default-playlist-import-folder=/config/playlists/import \
  --default-playlist-export-folder=/config/playlists/export \
  --default-playlist-backup-folder=/config/playlists/backup \
  ${PORTS}


/*
#!/bin/sh

mkdir -p /data/transcode
ln -s /usr/bin/ffmpeg /data/transcode/ffmpeg
ln -s /usr/bin/lame /data/transcode/lame

chown -R $UID:$GID /data /playlists /libresonic

exec su-exec $UID:$GID tini -- \
java -Xmx256m \
  -Dserver.host=0.0.0.0 \
  -Dserver.port=4040 \
  -Dserver.contextPath=/ \
  -Dlibresonic.home=/data \
  -Dlibresonic.host=0.0.0.0 \
  -Dlibresonic.port=4040 \
  -Dlibresonic.contextPath=/ \
  -Dlibresonic.defaultMusicFolder=/musics \
  -Dlibresonic.defaultPodcastFolder=/podcasts \
  -Dlibresonic.defaultPlaylistFolder=/playlists \
  -Djava.awt.headless=true \
  -jar libresonic.war

*/