FROM ubuntu:14.04
MAINTAINER myzero1 <myzero1@sina.com>

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Replace the software sources
RUN sudo cp /etc/apt/sources.list /etc/apt/sources.list_backup
ADD ./sources.list /etc/apt/sources.list

RUN apt-get update
RUN apt-get -y upgrade

# Basic Requirements
RUN apt-get -y install \
        apache2 \
        libapache2-mod-php5 \
        php5-cli \
        php5-fpm \
        php5-curl \
        libcurl4-openssl-dev \
        curl \
        git \
        unzip

# add and config mysql 
RUN echo 'mysql-server-5.6 mysql-server/root_password password root' | sudo debconf-set-selections
RUN echo 'mysql-server-5.6 mysql-server/root_password_again password root' | sudo debconf-set-selections

RUN apt-get -y install \
        mysql-client-core-5.6 \
        mysql-client-5.6 \
        mysql-server-core-5.6 \
        mysql-server-5.6 

RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# apache config

# add and config phpmyadmin
RUN apt-get -y install phpmyadmin
RUN ln -s /usr/share/phpmyadmin /var/www/html

# Lamp Initialization and Startup Script
ADD ./myzero1_start.sh /myzero1_start.sh
RUN chmod 755 /myzero1_start.sh
RUN echo "bash /myzero1_start.sh" >> /etc/bash.bashrc

# private expose
EXPOSE 3306
EXPOSE 80

# volume for mysql database and website install
# VOLUME ["/var/lib/mysql", "/usr/share/nginx/www"]

# CMD ["/bin/bash", "/start.sh"]
