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
        nginx \
        php5-fpm \
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

# nginx config
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf
RUN find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# nginx site conf
ADD ./nginx-site.conf /etc/nginx/sites-available/default

# add and config phpmyadmin
RUN apt-get -y install phpmyadmin
RUN ln -s /usr/share/phpmyadmin /var/www/html

# Lnmp Initialization and Startup Script
ADD ./myzero1_start.sh /myzero1_start.sh
RUN chmod 755 /myzero1_start.sh
RUN echo "bash /myzero1_start.sh" >> /etc/bash.bashrc

# private expose
EXPOSE 3306
EXPOSE 80

# volume for mysql database and website install
# VOLUME ["/var/lib/mysql", "/usr/share/nginx/www"]

# CMD ["/bin/bash", "/start.sh"]
