FROM alpine:3.19

RUN apk add --no-cache \
    build-base \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    linux-headers \
    wget \
    git \
    libxml2-dev \
    libxslt-dev

ARG NGINX_VERSION=1.25.3
ARG DAV_EXT_COMMIT=master

# Nginx + dav + dav ext
RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -zxvf nginx-${NGINX_VERSION}.tar.gz && \
    git clone https://github.com/arut/nginx-dav-ext-module.git && \
    cd nginx-dav-ext-module && \
    git checkout ${DAV_EXT_COMMIT} && \
    cd ../nginx-${NGINX_VERSION} && \
    ./configure \
        --with-http_dav_module \
        --add-dynamic-module=../nginx-dav-ext-module \
        --with-http_xslt_module \
        --with-http_ssl_module \
        --with-compat \
        --modules-path=/usr/local/nginx/modules && \
    make && make install

RUN mkdir -p /var/webdav/tmp && \
    chmod 755 /var/webdav

COPY nginx.conf /usr/local/nginx/conf/nginx.conf

EXPOSE 80
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
