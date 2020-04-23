FROM looklikethatguy/phpfm:v1

RUN apk update && apk upgrade
RUN apk add php7-fpm php7-curl bash
RUN sed -i -e "s/listen\s*=\s*127.0.0.1:9000/listen = 9000/g" /etc/php7/php-fpm.d/www.conf

EXPOSE 9000

CMD ["php-fpm7", "--nodaemonize"]