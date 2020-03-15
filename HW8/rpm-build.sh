#!/bin/bash
# Установка необходимых утилит
yum install -y gcc redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils

# Загрузка пакета с исходным кодом
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm

# Установка пакета. Подкаталоги для сборки создаются автоматически
rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm

# Скачиваем библиотеку openssl и разархивируем её
wget https://www.openssl.org/source/latest.tar.gz && tar -xvf latest.tar.gz

# Установка зависимостей
yum-builddep rpmbuild/SPECS/nginx.spec -y

# Скачиваем подготовленный файл спецификаций, в котором указан путь к openssl
wget https://github.com/looklikethatguy/otus012020/raw/master/HW8/nginx.spec -O rpmbuild/SPECS/nginx.spec -r

# Собираем пакет
rpmbuild -bb rpmbuild/SPECS/nginx.spec

# Устанавливаем собранный пакет и запускаем сервис
yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
systemctl start nginx

# Создаём репозиторий
# Создаём каталог и копируем в него наш пакет
mkdir /usr/share/nginx/html/repo
cp rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
createrepo /usr/share/nginx/html/repo/

# Кладём конфиг nginx со включенным автоиндексом и перезапускаем сервис
wget https://github.com/looklikethatguy/otus012020/raw/master/HW8/default.conf -O /etc/nginx/conf.d/default.conf -r
nginx -t
nginx -s reload

# Создаём конфигурацию репозитория
echo '[otus]' >> /etc/yum.repos.d/otus.repo 
echo 'name=otus-linux'\n >> /etc/yum.repos.d/otus.repo
echo 'baseurl=http://localhost/repo'\n >> /etc/yum.repos.d/otus.repo
echo 'gpgcheck=0'\n >> /etc/yum.repos.d/otus.repo
echo 'enabled=1'\n >> /etc/yum.repos.d/otus.repo

# Устанавливаем пакет percona из локального репозитория
yum install percona-release -y
