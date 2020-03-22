## Ansible

Подготовить стенд на Vagrant как минимум с одним сервером. На этом сервере используя Ansible необходимо развернуть nginx со следующими условиями:
- необходимо использовать модуль yum/apt
- конфигурационные файлы должны быть взяты из шаблона jinja2 с перемененными
- после установки nginx должен быть в режиме enabled в systemd
- должен быть использован notify для старта nginx после установки
- сайт должен слушать на нестандартном порту - 8080, для этого использовать переменные в Ansible

- *Сделать все это с использованием Ansible роли

### NB Все действия выполнялись в виртуальной машине Centos7 развёрнутой средствами Vagrant и при помощи Ansible версии 2.9.6. В обоих случаях результат выполнения один и тот же, что удовлетворяет требованию консистентности.

### ДЗ со "*"
Оформить практическую часть в виде Ansible роли. Результат работы находится в каталоге `Ansible_role`. Для запуска плейбука нужно выполнить `ansible-playbook role_playbook.yml` из каталога `Ansible_role`. Результат работы плейбука зафиксирорван утилитой `script` в файле `practice_result`.

### Практика
Результат выполнения практической работы, а так же все конфигурационные файлы находятся в каталоге `Ansible practice`. После команды `vagrant up` нужно выполнить с хоста, на котором установлена `ansible`, `ansible-playbook playbooks/nginx.yml`. После успешного запуска плейбука, можно проверить наличие сервиса `nginx` и его работу: `ansible nginx -m systemd -a name=nginx | grep "ActiveState"` и `curl http://192.168.11.150:8080`. Результат зафиксирорван утилитой `script` в файле `practice_result`.

Очень много информации черпал по ссылкам:
- [Официальная документация с примерами]:(https://docs.ansible.com/)
- [Примеры конфигураций .yml файлов]:(https://github.com/ansible/ansible-examples)