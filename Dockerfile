# FROM alpine:3.10
FROM ubuntu:18.04

# VOLUME ["/var/cache/nginx"]
# RUN build_pkgs="build-base linux-headers openssl-dev pcre-dev zlib-dev" \
#   && runtime_pkgs=" openssl pcre zlib" \
#   && apk --update add ${build_pkgs} ${runtime_pkgs} 
RUN apt-get update && apt-get install -y build-essential libtool openssl libssl-dev libpcre3 libpcre3-dev zlib1g-dev
COPY nginx-1.14.2.tar.gz /
COPY lua-nginx-module-0.10.15.tar.gz /
COPY LuaJIT-2.0.5.tar.gz /
COPY ngx_devel_kit-0.3.1rc1.tar.gz /
COPY prometheus.lua /
RUN  tar -xzvf /LuaJIT-2.0.5.tar.gz && cd LuaJIT-2.0.5 && make && make install && ldconfig && cd / \
  && tar -zxvf ngx_devel_kit-0.3.1rc1.tar.gz \
  && tar -zxvf lua-nginx-module-0.10.15.tar.gz \
  && tar -vxzf /nginx-1.14.2.tar.gz \
  && cd /nginx-1.14.2 \
  && ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --user=root \
    --group=root \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --with-http_slice_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-file-aio \
    --with-http_v2_module \
    --add-module=/ngx_devel_kit-0.3.1rc1 \
    --add-module=/lua-nginx-module-0.10.15 \
  && make \
  && make install \
# && rm -rf /tmp/* \
# && apk del ${build_pkgs} \
# && rm -rf /var/cache/apk/*
  && rm -rf /LuaJIT-2.0.5.tar.gz \
  # && rm -rf /nginx-1.14.2 \
  && rm -rf /nginx-1.14.2.tar.gz \
  && rm -rf /ngx_devel_kit-0.3.1rc1.tar.gz \
  && rm -rf /lua-nginx-module-0.10.15.tar.gz

COPY nginx.conf /etc/nginx/
COPY prometheus.conf /etc/nginx/conf.d/
# COPY default.conf /etc/nginx/conf.d/
EXPOSE 80 443 9145
CMD ["nginx", "-g", "daemon off;"]