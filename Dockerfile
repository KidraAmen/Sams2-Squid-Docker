FROM debian:11
RUN apt update -y && apt upgrade -y
RUN apt install -y gnupg2 apt-transport-https lsb-release ca-certificates curl wget && \
    sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' && \
    wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - 
RUN apt update && apt -y install \
	php5.6 php5.6-mysql php5.6-dev php5.6-gd \
	libpcre3 libpcre3-dev make automake autoconf mariadb-server \
	libapache2-mod-php5.6 libmariadb-dev-compat \ 
	libtool libxml2-dev libpng-dev apache2 squid

COPY files/. /home/
ADD sams2.tar /home/

WORKDIR /home/sams2
RUN dpkg --force-depends -i /home/gcc4.9/*.deb && \
    mkdir -p /usr/share/sams2/data && \
    make CC=/usr/bin/gcc-4.9 -f Makefile.cvs && \ 
    ./configure && \ 
    make CC=/usr/bin/gcc-4.9 CXX=/usr/bin/g++-4.9 && \ 
    make CC=/usr/bin/gcc-4.9 install && \
    cp debian/init.d /etc/init.d/sams2 && \
    ln -s /usr/share/sams2 /var/www/sams2 && \
    chmod 777 /var/www/sams2/data /etc/init.d/sams2 && \
    cp /home/sams2_apache.conf /etc/apache2/sites-available/sams2.conf && \
    cp /home/sams2.conf /usr/etc/sams2.conf && \
    a2ensite sams2 && a2dissite 000-default && \
    service mariadb start && \ 
    mysql -uroot -e "CREATE DATABASE sams2db DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;" && \ 
    mysql -uroot -e "GRANT ALL PRIVILEGES ON sams2db.* TO sams2user@localhost IDENTIFIED BY 'sams2password';" && \
    mysql -uroot sams2db < /home/sams2.sql && \
    touch /var/log/sams2.log && \
    cat /etc/squid/squid.conf >> /home/squid.add.conf && \
    mv /home/squid.add.conf /etc/squid/squid.conf && \
    cp /home/sq.conf /etc/squid.conf && \
    touch /etc/squid/sams2.ncsa && \
    chmod +x /home/start.sh

RUN ls | grep -v "start.sh" | xargs rm -rfv
CMD bash /home/start.sh && /bin/bash
