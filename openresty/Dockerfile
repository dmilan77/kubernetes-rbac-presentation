FROM openresty/openresty:alpine-fat
RUN apk add -U openssl-dev git ca-certificates
RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-openidc
ENTRYPOINT ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
