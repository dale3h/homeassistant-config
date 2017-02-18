#!/bin/bash

VERSION="1.11.2.2"

apt-get update && \
apt-get install -y unzip \
  ca-certificates \
  build-essential \
  vim-tiny \
  curl \
  telnet \
  libreadline-dev \
  libncurses5-dev \
  libpcre3-dev \
  libssl-dev \
  luarocks \
  libgeoip-dev \
  nano \
  perl \
  wget \
  make

wget https://openresty.org/download/openresty-$VERSION.tar.gz && \
  tar -xzvf openresty-*.tar.gz && \
  rm -f openresty-*.tar.gz && \
  cd openresty-* && \
  sed -ie 's/DEFAULT_ENCODE_EMPTY_TABLE_AS_OBJECT 1/DEFAULT_ENCODE_EMPTY_TABLE_AS_OBJECT 0/g' bundle/lua-cjson-*/lua_cjson.c && \
  ./configure \
    --with-luajit \
    --with-pcre-jit \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-client-body-temp-path=/var/lib/nginx/body \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --http-log-path=/var/log/nginx/access.log \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --http-scgi-temp-path=/var/lib/nginx/scgi \
    --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
    --lock-path=/var/lock/nginx.lock \
    --pid-path=/run/nginx.pid \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-http_geoip_module \
    --with-http_ssl_module \
    --with-http_sub_module \
    --with-ipv6 \
    --with-mail \
    --with-mail_ssl_module \
    --with-http_secure_link_module \
    --with-http_v2_module \
    --with-http_auth_request_module \
    -j2
  make && \
  make install && \
  make clean && \
  cd .. && \
  rm -rf openresty-* && \
  ldconfig

wget https://github.com/pintsized/lua-resty-http/archive/master.zip && \
  unzip master.zip && \
  cp lua-resty-http-master/lib/resty/*.lua /usr/local/openresty/lualib/resty/ && \
  rm -rf master.zip lua-resty-http-master
