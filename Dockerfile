FROM debian:jessie
MAINTAINER LWB

ENV HOST=HOST \
    RELAY=RELAY \
    DOMAIN=DOMAIN

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends \
    apache2-mpm-event libapache2-mod-fastcgi \
    php5-fpm php5-gd php5-mysql php5-sybase php5-ldap php5-dev php5-curl php5-memcache php5-json php-pear \
    make wget bsd-mailx \
    drush supervisor \
    postfix

RUN a2enmod rewrite expires actions fastcgi headers alias && \
    echo 'opcache.memory_consumption = 128' >> /etc/php5/fpm/php.ini && \
    echo 'opcache.max_accelerated_files = 4000' >> /etc/php5/fpm/php.ini && \
    echo 'opcache.revalidate_freq = 240' >> /etc/php5/fpm/php.ini

RUN rm -f /var/www/html/index.html && \
    apt-get -y --purge remove php5-dev make && \ 
    apt-get -y --purge autoremove && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/tmp/* && \
    rm -rf /tmp/* 

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY 000-default.conf /etc/apache2/sites-available/
COPY php5-fpm.conf /etc/apache2/conf-available/

RUN chown -R www-data:www-data /var/www && \
    touch /usr/lib/cgi-bin/php5.fcgi && \
    chown -R www-data:www-data /usr/lib/cgi-bin && \
    a2enconf php5-fpm

VOLUME /var/www/html

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80

CMD ["/usr/bin/supervisord"]