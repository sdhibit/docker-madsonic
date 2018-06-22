FROM alpine:latest as builder

ARG APP_VERSION=6.2
ARG APP_REVISION=9080
ARG APP_DATE=20161222

ENV APP_NAME madsonic
ENV APP_BASEURL http://www.madsonic.org/download 
ENV APP_PKGNAME ${APP_DATE}_${APP_NAME}-${APP_VERSION}.${APP_REVISION}-war-jspc.zip 
ENV TRAN_PKGNAME ${APP_DATE}_${APP_NAME}-transcode-linux-x64.zip 
ENV APP_URL ${APP_BASEURL}/${APP_VERSION}/${APP_PKGNAME} 
ENV TRAN_URL ${APP_BASEURL}/transcode/${TRAN_PKGNAME}

RUN apk --update upgrade \
 && apk --no-cache add \
    wget \
    unzip

RUN mkdir -p /app/transcode \
 && wget -O "/tmp/madsonic.zip" ${APP_URL} \
 && wget -O "/tmp/transcode.zip" ${TRAN_URL} \ 
 && unzip "/tmp/madsonic.zip" -d "/app" \
 && unzip "/tmp/transcode.zip" -d "/app/transcode" \
 && rm "/tmp/madsonic.zip" \
 && rm "/tmp/transcode.zip" 

#--------------------------------------------

FROM sdhibit/alpine-s6:3.7
LABEL maintainer="Steve Hibit <sdhibit@gmail.com>"

COPY --from=builder /app ${APP_PATH}

RUN apk --update upgrade \
 && apk --no-cache add \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    libressl \
    openjdk8-jre-base

COPY root /

RUN chmod +x /etc/services.d/*/run

VOLUME ["/config"]

# HTTP ports
EXPOSE 4040
EXPOSE 4050
