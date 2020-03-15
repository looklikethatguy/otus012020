Размещаем свой RPM в своем репозитории
Цель: В результате выполнения ДЗ студент создаст репо. Студент получил навыки работы с RPM.
1) создать свой RPM (можно взять свое приложение, либо собрать к примеру апач с определенными опциями)
2) создать свой репо и разместить там свой RPM

* реализовать дополнительно пакет через docker 

Результат сохранён в файле вывода утилиты `script` под именем `result`.

Процесс описан ниже:

# Установка необходимых утилит
`yum install -y gcc redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils`

# Загрузка пакета с исходным кодом
`wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm`

# Установка пакета. Подкаталоги для сборки создаются автоматически
`rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm`

# Скачиваем библиотеку openssl и разархивируем её
`wget https://www.openssl.org/source/latest.tar.gz && tar -xvf latest.tar.gz`

# Установка зависимостей
`yum-builddep rpmbuild/SPECS/nginx.spec -y`

# Меняем файл `nginx.spec`, в котором указываем путь к распакованнаму openssl в секции `%Build`
`--with-openssl=/root/openssl-1.1.1d`

# Собираем пакет
`rpmbuild -bb rpmbuild/SPECS/nginx.spec`

# Устанавливаем собранный пакет и запускаем сервис
```yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
systemctl start nginx```

# Создаём репозиторий
# Создаём каталог и копируем в него наш пакет
```mkdir /usr/share/nginx/html/repo
cp rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
createrepo /usr/share/nginx/html/repo/```

# Изменяем конфиг nginx и включаем автоиндекс в секции  location / в файле /etc/nginx/conf.d/default.conf и применяем изменения
```location / {
root   /usr/share/nginx/html;
index  index.html index.htm;
autoindex on;
}

nginx -t
nginx -s reload```

# Создаём конфигурацию репозитория
```cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF```

# Устанавливаем пакет percona из локального репозитория
```yum install percona-release -y
yum list installed | grep percona```
