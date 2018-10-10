FROM alpine:latest as builder

ARG APP_VERSION=6.2
ARG APP_REVISION=9080
ARG APP_DATE=20161222

ARG APP_NAME=madsonic
ARG APP_BASEURL="http://www.madsonic.org/download"
ARG APP_PKGNAME="${APP_DATE}_${APP_NAME}-${APP_VERSION}.${APP_REVISION}-standalone.tar.gz" 
ARG APP_URL="${APP_BASEURL}/${APP_VERSION}/${APP_PKGNAME}"
 
RUN apk --update upgrade \
 && apk --no-cache add \
    curl

RUN mkdir -p /app \ 
 && curl -sSL ${APP_URL} | tar xfz - -C /app

#--------------------------------------------

FROM sdhibit/alpine-s6:3.7
LABEL maintainer="Steve Hibit <sdhibit@gmail.com>"

COPY --from=builder /app ${APP_PATH}

RUN apk --update upgrade \
 && apk --no-cache add \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    ffmpeg \
    lame \
    libressl \
    openjdk8-jre-base

COPY root /

RUN chmod -R +x /etc/services.d/*/run

VOLUME ["/config"]

# HTTP ports
EXPOSE 4040
EXPOSE 4050
