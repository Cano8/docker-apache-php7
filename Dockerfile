FROM ubuntu:xenial
MAINTAINER NJ Darda <jedrekdarda@gmail.com>

RUN apt-get update && apt-get -y install software-properties-common python-software-properties

# Install base packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

# Install apache, php and utils
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install --no-install-recommends apt-utils \
        curl \
        apache2 \
        php \
        php-common \
        libapache2-mod-php \
        php-cli \
        php-curl \
        php-xdebug \
        php-imagick \
        php-mysql \
        php-pgsql \
        php-redis \
        php-mcrypt \
        php-intl \
        php-gd \
        php-pear \
        php-memcache \
	php-zip \
	git \
        vim \
	zip \
	unzip \
	php-xml \
	php-simplexml

RUN rm -rf /var/lib/apt/lists/*

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# debugger setup
# RUN echo "xdebug.remote_enable=1" >> /etc/php/7.0/apache2/php.ini
# RUN echo "xdebug.remote_host=10.0.2.2" >> /etc/php/7.0/apache2/php.ini # 10.0.2.2 is the ip of the host machine on Virtual Box
# RUN echo "xdebug.max_nesting_level=250" >> /etc/php/7.0/apache2/php.ini

EXPOSE 80
WORKDIR /share/
RUN chown www-data:www-data /var/www -R

CMD ["/run.sh"]
