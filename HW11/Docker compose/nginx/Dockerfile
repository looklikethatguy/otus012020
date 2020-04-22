FROM alpine:latest

RUN apk update && apk upgrade
RUN apk add nginx bash

RUN mkdir /www && \
    mkdir -p /run/nginx && \
    chmod 755 /www

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /www/index.html
COPY index.php /www/index.php

EXPOSE 80

CMD ["nginx"]