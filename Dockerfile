FROM php:7.1-apache

RUN echo "deb http://archive.debian.org/debian/ buster main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian/ buster-updates main" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    make \
    wget \
    unzip \
    && a2enmod rewrite \
    && docker-php-ext-install pdo_mysql mysqli

COPY docker-apache.conf /etc/apache2/sites-available/000-default.conf

COPY . /var/www/html

RUN cp /var/www/html/docker-bootstrap.php /var/www/html/bootstrap.php

WORKDIR /var/www/html

RUN wget https://getcomposer.org/installer -O composer-setup.php && \
    php composer-setup.php --install-dir=. --filename=composer.phar --version=2.2.12 && \
    rm composer-setup.php

RUN make install-aws

RUN rm /var/www/html/web/css/bootstrap.min.css
RUN rm /var/www/html/web/fonts

RUN ln -s /var/www/html/vendor/twbs/bootstrap/dist/css/bootstrap.min.css /var/www/html/web/css/bootstrap.min.css
RUN ln -s /var/www/html/vendor/twbs/bootstrap/dist/fonts /var/www/html/web/fonts

RUN chown -R www-data:www-data /var/www/html