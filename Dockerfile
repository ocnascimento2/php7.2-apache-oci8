FROM ubuntu:18.04

WORKDIR /var/www/html

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
  curl \
  # Install git
  git \
  # Install apache
  apache2 \
  # Install php 7.2
  libapache2-mod-php7.2 \
  php7.2-cli \
  php7.2-json \
  php7.2-curl \
  php7.2-fpm \
  php7.2-gd \
  php7.2-ldap \
  php7.2-mbstring \
  php7.2-mysql \
  php7.2-soap \
  php7.2-sqlite3 \
  php7.2-xml \
  php7.2-zip \
  php7.2-intl \
  php-imagick \
  # Install tools
  openssl \
  nano \
  unzip \
  graphicsmagick \
  imagemagick \
  ghostscript \
  mysql-client \
  iputils-ping \
  locales \
  sqlite3 \
  ca-certificates

RUN a2enmod rewrite

RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# ORACLE oci
RUN mkdir /opt/oracle

ADD instantclient-basic-linux.x64-12.2.0.1.0.zip /opt/oracle
ADD instantclient-sdk-linux.x64-12.2.0.1.0.zip /opt/oracle

RUN cd /opt/oracle \
  && unzip /opt/oracle/instantclient-basic-linux.x64-12.2.0.1.0.zip -d /opt/oracle \
  && unzip /opt/oracle/instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /opt/oracle

RUN ln -s /opt/oracle/instantclient_12_2/libclntsh.so.12.1 /opt/oracle/instantclient_12_2/libclntsh.so \
  && ln -s /opt/oracle/instantclient_12_2/libocci.so.12.1 /opt/oracle/instantclient_12_2/libocci.so

RUN echo /opt/oracle/instantclient_12_2 > /etc/ld.so.conf.d/oracle-instantclient

RUN ldconfig

RUN apt-get install php-dev php-pear build-essential libaio1 -y

RUN pecl channel-update pecl.php.net

RUN echo 'instantclient,/opt/oracle/instantclient_12_2' | pecl install oci8

RUN echo "extension=oci8.so" >> /etc/php/7.2/fpm/php.ini \
  && echo "extension=oci8.so" >> /etc/php/7.2/cli/php.ini \
  && echo "extension=oci8.so" >> /etc/php/7.2/apache2/php.ini

RUN echo "export LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2" >> /etc/apache2/envvars \
  && echo "export ORACLE_HOME=/opt/oracle/instantclient_12_2" >> /etc/apache2/envvars \
  && echo "LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2:$LD_LIBRARY_PATH" >> /etc/environment

RUN export LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2 \
  && sh -c "echo /opt/oracle/instantclient_12_2 > /etc/ld.so.conf.d/oracle-instantclient.conf" \
  && ldconfig


RUN chmod -R 775 /var/www/html

RUN touch index.php \
  && echo "<?php phpinfo();" >> index.php

# COPY . /var/www/html

CMD apachectl -D FOREGROUND
