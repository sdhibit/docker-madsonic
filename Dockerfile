FROM phusion/baseimage:0.9.16
MAINTAINER Steve Hibit <sdhibit@gmail.com>

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Set correct environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL          C.UTF-8
ENV LANG            en_US.UTF-8
ENV LANGUAGE        en_US.UTF-8

#Set Madsonic Package Information
ENV APP_NAME madsonic
ENV APP_VERSION 6.0
ENV APP_SUBVERSION 7080
ENV APP_DATE 20150814

ENV APP_BASEURL http://madsonic.org/download
ENV APP_PKGNAME ${APP_DATE}_${APP_NAME}-${APP_VERSION}.${APP_SUBVERSION}-standalone.tar.gz
ENV APP_URL ${APP_BASEURL}/${APP_VERSION}/${APP_PKGNAME}
ENV APP_HOME /var/madsonic

# Set user nobody uid and gid
RUN usermod -u 99 nobody \
 && usermod -g 100 nobody

# Install Apt Packages
RUN apt-get update && apt-get install --no-install-recommends -y \
  locales \
  openjdk-7-jre-headless \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \ 
     /tmp/* \ 
     /var/tmp/* \
     /usr/share/man \ 
     /usr/share/groff \ 
     /usr/share/info \
     /usr/share/lintian \ 
     /usr/share/linda \ 
     /var/cache/man \
  && (( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) \
  && (( find /usr/share/doc -empty|xargs rmdir || true )) 


# Download & Install Madsonic
RUN mkdir -p "${APP_HOME}" \
  && curl -kL "${APP_URL}" | tar xz -C "${APP_HOME}" \
  && mkdir -p "${APP_HOME}/transcode" \
  && chown -R nobody:users /var/madsonic \
  && chmod -R 755 /var/madsonic

# Force Madsonic to run in foreground
RUN sed -i 's/-jar madsonic-booter.jar > \${LOG} 2>\&1 \&/-jar madsonic-booter.jar > \${LOG} 2>\&1/g' \
    /var/madsonic/madsonic.sh

VOLUME /config

# HTTP(S) ports
EXPOSE 4040
EXPOSE 4050

# Add services to runit
ADD madsonic.sh /etc/service/madsonic/run
RUN chmod +x /etc/service/*/run


#  && wget -O /var/madsonic/madsonic.zip http://www.madsonic.org/download/${PKG_VERA}/${PKG_DATE}_${PKG_NAME}-${PKG_VER}-standalone.zip \
#  && wget -O /var/madsonic/transcode/transcode.zip http://www.madsonic.org/download/transcode/${PKG_DATE}_${PKG_NAME}-transcode_latest_x64.zip \
#  && unzip /var/madsonic/madsonic.zip -d /var/madsonic \
#  && unzip /var/madsonic/transcode/transcode.zip -d /var/madsonic/transcode \
