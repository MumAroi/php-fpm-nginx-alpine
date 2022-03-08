FROM php:8-fpm-alpine

# Add docker-php-extension-installer script
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install dependencies
RUN apk update && apk add --no-cache \
    bash \
    curl \
    shadow \
    git \
    freetype-dev \
    g++ \
    gcc \
    git \
    icu-dev \
    icu-libs \
    libc-dev \
    libzip-dev \
    make \
    mysql-client \
    oniguruma-dev \
    openssh-client \
    postgresql-libs \
    rsync \
    zlib-dev \
    supervisor \
    nginx

# Install php extensions
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions \
    @composer \
    imagick-stable \
    xdebug-stable \
    bcmath \
    calendar \
    exif \
    gd \
    intl \
    pdo_mysql \
    pcntl \
    soap \
    zip \ 
    opcache \
    mbstring \
    iconv

# fix work iconv library with alphine
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Clear cache
RUN rm -rf /tmp/* /var/cache/apk/* 

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy code to /var/www
COPY --chown=www:www-data ./src/your-project /var/www/html/your-project

# add root to www group
RUN chmod -R ug+w /var/www/html/your-project/storage

# Copy nginx/php/supervisor configs
COPY docker/config/supervisor.conf /etc/conf.d/supervisord.conf
COPY docker/config/php.ini /usr/local/etc/php/conf.d/app.ini
COPY docker/config/nginx.conf /etc/nginx/nginx.conf
COPY docker/run.sh /var/www/html/your-project/docker/run.sh

# PHP Error Log Files
RUN mkdir /var/log/php
RUN touch /var/log/php/errors.log && chmod 777 /var/log/php/errors.log

# Setup document root
WORKDIR /var/www/html/your-project

RUN composer install --optimize-autoloader --no-dev
RUN cp .env.example .env
RUN php artisan key:generate
RUN php artisan storage:link

RUN chmod +x /var/www/html/your-project/docker/run.sh

EXPOSE 80

ENTRYPOINT ["/var/www/html/your-project/docker/run.sh"]