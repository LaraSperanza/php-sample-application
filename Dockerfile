# 1. Empezamos con la imagen original y correcta para el proyecto
FROM php:7.1-apache

# 2. CORRECCIÓN PARA EL ERROR DE "BUSTER" (como en tu archivo original)
RUN echo "deb http://archive.debian.org/debian/ buster main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian/ buster-updates main" >> /etc/apt/sources.list

# 3. Instalamos dependencias y extensiones de PHP
RUN apt-get update && apt-get install -y \
    make \
    wget \
    unzip \
    && a2enmod rewrite \
    && docker-php-ext-install pdo_mysql mysqli

# 4. (MODIFICADO) Copiamos la config de Apache optimizada para Docker
# Esto asegura que los logs de Apache vayan a stdout/stderr,
# lo cual es esencial para verlos en CloudWatch.
COPY docker-apache.conf /etc/apache2/sites-available/000-default.conf

# 5. Copiamos el código de la aplicación
COPY . /var/www/html

RUN cp /var/www/html/docker-bootstrap.php /var/www/html/bootstrap.php

# 6. Establecemos el directorio de trabajo
WORKDIR /var/www/html

# 7. Instalamos Composer v2.2 (LTS para PHP 7.1)
RUN wget https://getcomposer.org/installer -O composer-setup.php && \
    php composer-setup.php --install-dir=. --filename=composer.phar --version=2.2.12 && \
    rm composer-setup.php

# 8. (MODIFICADO) Ejecutamos 'make' con el objetivo de AWS
# Esto ejecutará 'install-aws' que creamos en el Makefile
RUN make install-aws

# 9. Damos permisos a Apache
RUN chown -R www-data:www-data /var/www/html