FROM debian:jessie
MAINTAINER Steve Hibit <sdhibit@gmail.com>

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody
RUN usermod -g 100 nobody

#Set Madsonic Package Information
ENV PKG_NAME madsonic
ENV PKG_VER 5.2.5420
ENV PKG_VERA 5.2
ENV PKG_DATE 20141214

# Add Oracle Java Repo
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
  && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

# Install Apt Packages
RUN apt-get update && apt-get install -y \
  ca-certificates \
  locales \
  oracle-java8-installer \
  oracle-java8-set-default \
  unzip \
  wget

# download madsonic
RUN mkdir -p /var/madsonic/transcode \
  && wget -O /var/madsonic/madsonic.zip http://www.madsonic.org/download/${PKG_VERA}/${PKG_DATE}_${PKG_NAME}-${PKG_VER}-standalone.zip \
  && wget -O /var/madsonic/transcode/transcode.zip http://www.madsonic.org/download/transcode/${PKG_DATE}_${PKG_NAME}-transcode_latest_x64.zip

# Set Locale
ENV LANG en_US.UTF-8
RUN locale-gen $LANG

# Install Madsonic
RUN mkdir -p /var/madsonic/transcode \
  && unzip /var/madsonic/madsonic.zip -d /var/madsonic \
  && unzip /var/madsonic/transcode/transcode.zip -d /var/madsonic/transcode \
  && chown -R nobody:users /var/madsonic \
  && chmod -R 755 /var/madsonic \
  && rm /var/madsonic/madsonic.zip \
  && rm /var/madsonic/transcode/transcode.zip

# Force Madsonic to run in foreground
RUN sed -i 's/-jar madsonic-booter.jar > \${LOG} 2>\&1 \&/-jar madsonic-booter.jar > \${LOG} 2>\&1/g' /var/madsonic/madsonic.sh

# Copy start.sh script
ADD start.sh /start.sh

 # apt clean
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*

# map /config
VOLUME /config
# map /media 
VOLUME /media

# expose port for http
EXPOSE 4040
# expose port for https
EXPOSE 4050

# Run Program
USER nobody
ENTRYPOINT ["/start.sh"]
