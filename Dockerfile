FROM debian:jessie
MAINTAINER LWB

ENV REPOSITORY=GIT

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends \
    libapache2-mod-php5 php5-mysql \
    git \
    supervisor && \
    rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite expires actions headers alias

RUN chown -R www-data:www-data /var/www

VOLUME /var/www/html

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80

CMD /usr/sbin/apache2ctl -D FOREGROUND
