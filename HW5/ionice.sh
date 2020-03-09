#!/bin/bash

echo "" > ionice.log
rm /tmp/*arch.tar.gz > /dev/null  2>&1

idle() {
sidle=$(date +%s)
nice -n 19 ionice -c 3 tar czvf /tmp/idle_arch.tar.gz /usr/src > /dev/null  2>&1
fidle=$(date +%s)
tidle=$(( $fidle - $sidle ))
echo -e "idle process time $tidle sec.\n" >> ionice.log
}

realtime() {
srealtime=$(date +%s)
ionice -c 2 -n 0 tar czvf /tmp/realtime_arch.tar.gz /usr/src > /dev/null  2>&1
frealtime=$(date +%s)
trealtime=$(( $frealtime - $srealtime ))
echo -e "realtime process time $trealtime sec.\n" >> ionice.log
}

idle & 
realtime &

tail -f ionice.log
