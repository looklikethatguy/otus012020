В этом файле описывается процесс созадния box образа для Vagrant на базе CentOS7 с обновлённым ядром версии 5.5.1 и установленными гостевыми дополнениями VirtualBox

После успешной установки Vagrant и VirtualBox на хостовую машину, я приступил  к обновлению ядра из репозитория elrepo согласно рекомендациям из методички:
```
sudo yum install -y http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm

sudo yum --enablerepo elrepo-kernel install kernel-ml -y

sudo grub2-mkconfig -o /boot/grub2/grub.cfg && sudo grub2-set-default 0
```
Далее я удалил ненужные пакеты, так как они конфликтовали бы с новыми. Делал это слудующим образом:

`sudo yum remove kernel-{3*,devel*,header*,tool*} -y`

После загрузил пакеты под текущую версию ядра:

`sudo yum --enablerepo elrepo-kernel install kernel-ml-{devel,header,tool} -y`

Следующим этапом я добавил каталог с ядром в переменные окружения:
```
KERN_DIR=/usr/src/kernels/`uname -r` %% export KERN_DIR
```
После чего приступил к ручной установке гостевых дополнений предварительно удалив устаревший пакет:
```
sudo yum remove virtualbox-guest-additions -y

curl https://download.virtualbox.org/virtualbox/6.1.2/VBoxGuestAdditions_6.1.2.iso -o VBoxGuestAdditions_6.1.2.iso %% sudo mount -o loop VBoxGuestAdditions_6.1.2.iso /mnt

sudo /mnt/VBoxGuestAdditions_6.1.2.iso/VBoxLinuxAdditions.run
```
После того, как дополнения были установлены и работа общих каталогов была проверена, я уменьшил размер виртуальной машины и средствами Vagrant создал новый бокс

На просторах сети был обнаружен скрипт очистки от Packer, частью содержимого которого я и воспользовался:
```
yum -y --enablerepo='*' clean all
rm -rf /tmp/*
dd if=/dev/zero of=/EMPTY bs=1M %% rm -f /EMPTY
```
После выполнения команды vagrant package --output centos7-5.5.1.box я получил бокс размером 1.2 Гб.

Полученный образ можно развернуть при помощи приложенного Vagrant файла.
