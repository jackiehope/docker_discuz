FROM php:5.6-apache

MAINTAINER y109<y109@qq.com>

RUN apt-get update && apt-get install -y \
        unzip php5-mysql  \
    && docker-php-ext-install mysql

#disuz version
ENV DZ_URL http://download.comsenz.com/DiscuzX/3.2/Discuz_X3.2_SC_UTF8.zip
ENV DZ_WWW_ROOT /var/www/html

ADD ${DZ_URL} /tmp/discuz.zip
RUN unzip /tmp/discuz.zip \
    && mv upload/* ${DZ_WWW_ROOT} \
    && cd ${DZ_WWW_ROOT} \
    && chmod a+w -R config data uc_server/data uc_client/data \
    && rm -rf /var/lib/apt/lists/*

#openshift does not allow to bind 80
#change default port from 80 to 8080
RUN sed -e 's/VirtualHost\ \*:80/VirtualHost\ \*:8080/' /etc/apache2/sites-available/000-default.conf
EXPOSE 8080

