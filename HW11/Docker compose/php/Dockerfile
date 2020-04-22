FROM alpine:latest

RUN apk update && apk upgrade
RUN apk add php7 php7-fpm php7-amqp php7-cgi bash

EXPOSE 9000

CMD ["php-fpm7", "--nodaemonize"]