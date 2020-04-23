FROM looklikethatguy/nginxphp:v1

RUN apk update && apk upgrade
RUN apk add nginx bash

RUN mkdir -p /run/nginx

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx"]