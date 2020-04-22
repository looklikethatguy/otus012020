FROM alpine:latest

RUN apk update && apk upgrade
RUN apk add nginx

RUN mkdir /www && \
    mkdir -p /run/nginx && \
    chmod 755 /www

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /www/index.html

EXPOSE 80

CMD ["nginx"]