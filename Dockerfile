FROM nginx:alpine

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache nginx-mod-http-dav-ext && \
    mkdir -p /var/webdav && \
    chown nginx:nginx /var/webdav

COPY nginx.conf /etc/nginx/nginx.conf