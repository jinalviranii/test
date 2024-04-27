FROM openresty/openresty:1.17.8.2-alpine-fat

RUN apk add --update openssl git gcc make openssl && \
    rm -rf /var/cache/apk/*

RUN apk update

RUN git config --global url."https://github.com/".insteadOf git@github.com:
RUN git config --global url."https://".insteadOf git://

RUN luarocks install lodash \
    && luarocks install rxi-json-lua \
    && luarocks install lua-resty-cookie \
    && luarocks install lua-resty-kafka \
    && luarocks install lua-resty-redis \
    && luarocks install lua-resty-hmac-ffi \
    && luarocks install net-url \
    && luarocks install lua-resty-env \
    && luarocks install router \
    && luarocks install lua-resty-redis-connector

RUN mkdir /srv/nginx-ingress
COPY spec/templates/server.config /etc/nginx/conf.d/default.conf
COPY spec/templates/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY . /srv/nginx-ingress
COPY lua/plugins /etc/nginx/lua/plugins

WORKDIR /etc/nginx/conf.d
ENTRYPOINT [ "sh", "/srv/nginx-ingress/spec/entrypoint.sh" ]
