FROM php:7.3-fpm-stretch

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y libmcrypt-dev zlib1g-dev curl\
    mysql-client libmagickwand-dev libzip-dev zip --no-install-recommends \
    && pecl install imagick\
    && docker-php-ext-install \
        pcntl exif mbstring mysqli pdo pdo_mysql zip tokenizer intl \
    && pecl install redis \
    && docker-php-ext-enable redis

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.0.12

COPY ./php.ini /usr/local/etc/php/conf.d/local.ini

# Install Nodejs and NPM
RUN apt-get update -yq \
    && apt-get install curl gnupg -yq \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash \
    && apt-get install nodejs -yq

# Puppeteer:
RUN apt-get install -y \
    lsb-release xdg-utils \
    gconf-service libasound2 libatk1.0-0 libc6 \
    libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 \
    libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
    libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 \
    libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 \
    libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    fonts-liberation libappindicator1 libnss3 \ 
    wget unzip libjpeg62-turbo-dev libxpm-dev \
    libfreetype6-dev libpng-dev libwebp-dev \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-webp-dir \
        --with-jpeg-dir \
        --with-png-dir \
        --with-zlib-dir \
        --with-xpm-dir \
        --with-freetype-dir \
    && docker-php-ext-install gd

EXPOSE 9000
