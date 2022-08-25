#!/bin/bash
service apache2 start
service mariadb start
service squid start
/usr/bin/sams2daemon -C /usr/etc/sams2.conf -f -d 100 -l file:/var/log/sams2.log