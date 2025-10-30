# Guarda esto como Dockerfile (Versión 100% Definitiva)

# 1. Empezamos con la imagen original y correcta para el proyecto
FROM php:7.1-apache

# 2. (NUEVO) CORRECCIÓN PARA EL ERROR DE "BUSTER" (404 Not Found)
# Apuntamos los repositorios de Debian 10 (buster) al archivo histórico
RUN echo "deb http://archive.debian.org/debian/ buster main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian/ buster-updates main" >> /etc/apt/sources.list

# 3. Instalamos dependencias del sistema y extensiones de PHP
RUN apt-get update && apt-get install -y \
    make \
    wget \
    unzip \
    && a2enmod rewrite \
    && docker-php-ext-install pdo_mysql mysqli

# 4. Copiamos el código de la aplicación
COPY . /var/www/html

# 5. Establecemos el directorio de trabajo
WORKDIR /var/www/html

# 6. (MODIFICADO) Instalamos Composer v2.2 (LTS para PHP 7.1) LOCALMENTE
# Esto "engaña" al Makefile para que use esta versión en lugar de descargar la última.
RUN wget https://getcomposer.org/installer -O composer-setup.php && \
    php composer-setup.php --install-dir=. --filename=composer.phar --version=2.2.12 && \
    rm composer-setup.php

# 7. Ejecutamos 'make' (ahora usará nuestro composer.phar v2.2)
RUN make

# 8. Damos permisos a Apache
RUN chown -R www-data:www-data /var/www/html