FROM alpine:3.3
MAINTAINER Steve Hibit <sdhibit@gmail.com>

# Install apk packages
RUN apk --update upgrade \
 && apk add \
  openjdk8-jre-base \
  unzip \
  wget \
 && rm /var/cache/apk/*

# Set Madsonic Package Information
ENV PKG_NAME madsonic 
ENV PKG_VER 6.1.8190 
ENV PKG_VERA 6.1 
ENV PKG_DATE 20160406 
ENV APP_BASEURL http://www.madsonic.org/download 
ENV APP_PKGNAME ${PKG_DATE}_${PKG_NAME}-${PKG_VER}-standalone.zip 
ENV TRAN_PKGNAME ${PKG_DATE}_${PKG_NAME}-transcode-linux-x64.zip 
ENV APP_URL ${APP_BASEURL}/${PKG_VERA}/${APP_PKGNAME} 
ENV TRAN_URL ${APP_BASEURL}/transcode/${TRAN_PKGNAME}
ENV APP_PATH /var/madsonic

# Download & Install Madsonic
RUN mkdir -p "${APP_PATH}/transcode" \
 && wget -O "${APP_PATH}/madsonic.zip" ${APP_URL} \
 && wget -O "${APP_PATH}/transcode/transcode.zip" ${TRAN_URL} \ 
 && unzip "${APP_PATH}/madsonic.zip" -d ${APP_PATH} \
 && unzip "${APP_PATH}/transcode/transcode.zip" -d "${APP_PATH}/transcode" \
 && rm "${APP_PATH}/madsonic.zip" \
 && rm "${APP_PATH}/transcode/transcode.zip" 

# Create user and change ownership
RUN mkdir /config \
 && addgroup -g 666 -S madsonic \
 && adduser -u 666 -SHG madsonic madsonic \
 && chown -R madsonic:madsonic \
    ${APP_PATH} \
    "/config"

VOLUME ["/config"]

# HTTP ports
EXPOSE 4040
EXPOSE 4050

# Add run script
ADD madsonic.sh /madsonic.sh
RUN chmod +x /madsonic.sh

USER madsonic
WORKDIR /var/madsonic

CMD ["/madsonic.sh"]
