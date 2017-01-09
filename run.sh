#!/bin/bash

service apache2 restart

echo 'loading config files'

stashPath="/share/stash/"
phpIni="/etc/php/7.0/apache2/php.ini"

if [ -f ${stashPath}docker/.bashrc ];
then
    rm /root/.bashrc
    ln -sf ${stashPath}docker/.bashrc /root/.bashrc
    echo '${stashPath}docker/.bashrc linked to ~/.bashrc'
else
    echo '${stashPath}docker/.bashrc not found'
    cp /root/.bashrc ${stashPath}docker/.bashrc
    rm /root/.bashrc
    ln -sf ${stashPath}docker/.bashrc /root/.bashrc
    echo '${stashPath}docker/.bashrc copied and linked to ~/.bashrc'
fi
chown 1000:1000 ${stashPath}docker/.bashrc


if [ -f ${stashPath}docker/.vimrc ];
then
    rm /root/.vimrc
    ln -sf ${stashPath}docker/.vimrc /root/.vimrc
    echo '${stashPath}docker/.vimrc linked to ~/.vimrc'
else
    echo '${stashPath}docker/.vimrc not found'
    if [ -f /root/.vimrc ];
    then
        cp /root/.vimrc ${stashPath}docker/.vimrc
        rm /root/.vimrc
        ln -sf ${stashPath}docker/.vimrc /root/.vimrc
        echo '${stashPath}docker/.vimrc copied and linked to ~/.vimrc'
    else
        echo 'set number' > ${stashPath}docker/.vimrc
        ln -sf ${stashPath}docker/.vimrc /root/.vimrc
        echo 'created ${stashPath}docker/.vimrc and linked to ~/.vimrc'
    fi
fi
chown 1000:1000 ${stashPath}docker/.vimrc


if [ -f ${stashPath}docker/vhosts.conf ];
then
    rm /etc/apache2/sites-enabled/000-default.conf
    ln -sf ${stashPath}docker/vhosts.conf /etc/apache2/sites-enabled/vhosts.conf
    echo '${stashPath}docker/vhosts.conf linked to /etc/apache2/sites-enabled/vhosts.conf'
else
    echo '${stashPath}docker/vhosts.conf not found'
    cp /etc/apache2/sites-enabled/000-default.conf ${stashPath}docker/vhosts.conf
    rm /etc/apache2/sites-enabled/000-default.conf
    ln -sf ${stashPath}docker/vhosts.conf /etc/apache2/sites-enabled/vhosts.conf
    echo '${stashPath}docker/vhosts.conf copied and linked to /etc/apache2/sites-enabled/vhosts.conf'
fi
chown 1000:1000 ${stashPath}docker/vhosts.conf


if [ -f ${stashPath}docker/php.ini ];
then
    rm ${phpIni}
    # rm /etc/php5/cli/php.ini
    ln -sf ${stashPath}docker/php.ini ${phpIni}
    # cp ${stashPath}docker/php.ini /etc/php5/cli/php.ini
    echo '${stashPath}docker/php.ini linked to etc/php5/apache2/php.ini'
else
    echo '${stashPath}docker/php.ini not found'
    cp ${phpIni} ${stashPath}docker/php.ini
    rm ${phpIni}
    ln -sf ${stashPath}docker/php.ini ${phpIni}
    echo '${stashPath}docker/php.ini copied and linked to ${phpIni}'
fi
chown 1000:1000 ${stashPath}docker/php.ini

if [ -f ${stashPath}docker/apache2.conf ];
then
    rm /etc/apache2/apache2.conf
    ln -sf ${stashPath}docker/apache2.conf /etc/apache2/apache2.conf
    echo '${stashPath}docker/apache2.conf linked to /etc/apache2/apache2.conf'
else
    echo '${stashPath}docker/apache2.conf not found'
    cp /etc/apache2/apache2.conf ${stashPath}docker/apache2.conf
    rm /etc/apache2/apache2.conf
    ln -sf ${stashPath}docker/apache2.conf /etc/apache2/apache2.conf
    echo '${stashPath}docker/apache2.conf copied and linked to /etc/apache2/apache2.conf'
fi
chown 1000:1000 ${stashPath}docker/apache2.conf

source /etc/apache2/envvars

sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# if [ ! -z "$LN" ]; then
    # echo "Creating a link: /share/ /var/www/$LN"
    # ln -sf  /share/ /var/www/$LN
# fi

if [ -f ${stashPath}docker/run.sh ];
then
    echo 'RUNNING CUSTOM SCRIPT'
    . ${stashPath}docker/run.sh
fi

phpenmod mcrypt

a2enmod php
a2enmod rewrite
a2enmod ssl
a2enmod headers

service apache2 restart

# tail -F /var/log/apache2/* &
# exec apache2 -D FOREGROUND

tail -F /var/log/apache2/error.log
