FROM php:7.3-apache

MAINTAINER jackieqiu<jackieqiu@126.com>

#disuz version
#because downloading discuz return 404
#ENV DZ_URL http://download.comsenz.com/DiscuzX/3.2/Discuz_X3.2_SC_UTF8.zip
#ENV DZ_WWW_ROOT /var/www/html

#ADD ${DZ_URL} /tmp/discuz.zip
#RUN unzip /tmp/discuz.zip \
#    && mv upload/* ${DZ_WWW_ROOT} \
#    && cd ${DZ_WWW_ROOT} \
#    && chmod a+w -R config data uc_server/data uc_client/data \
#    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html/
COPY upload .

RUN ls /var/www/html/ \
    && cd /var/www/html/ \
    && chmod -R a+w config data uc_server/data uc_client/data

#openshift does not allow to bind 80
#change default port from 80 to 8080
RUN sed -i -e 's/VirtualHost\ \*:80/VirtualHost\ \*:8080/' /etc/apache2/sites-available/000-default.conf \
    && sed -i -e 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
    && /usr/local/bin/docker-php-ext-install mysqli
EXPOSE 8080
