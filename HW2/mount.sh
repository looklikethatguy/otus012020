#!/bin/bash
#Установка необходимых утилит
yum install -y mdadm smartmontools hdparm gdisk
#Обнуление суперблока
mdadm --zero-superblock --force /dev/sd{b,c,d,e,f,g}
#Создание RAID массива уровня 10 из 4 дисков
mdadm --create --verbose /dev/md0 -l 10 -n 6 /dev/sd{b,c,d,e,f,g}
#Внесение информации о массиве в файл mdadm.conf
mkdir /etc/mdadm/
echo "DEVICE partitions" >> /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
#Создание таблицы разделов на массиве
parted -s /dev/md0 mklabel gpt
#Создание раздела на весь объём свободного пространства
parted /dev/md0 mkpart primary ext4 0% 100%
#Создание файловой системы
mkfs.ext4 /dev/md0
#Создание каталога для монтирования и монтирование раздела
mkdir /raid/ &&	mount /dev/md0 /raid/
#Вносим изменения в fstab для автоматического монтирования массива
echo /dev/md0      /raid/     ext4    defaults    0 0 >> /etc/fstab
#Информация о дисках и точках монтирования
echo "Check storage"
df -h
lsblk
