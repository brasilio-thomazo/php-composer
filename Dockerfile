FROM alpine:latest as php_cli

RUN apk add --no-cache --no-interactive bash icu-data-full php82 php82-zip \
    php82-xsl php82-xmlwriter php82-xmlreader php82-xml php82-tokenizer \
    php82-tidy php82-sysvshm php82-sysvsem php82-sysvmsg php82-sodium \
    php82-sockets php82-bz2 php82-simplexml php82-session php82-phar php82-pear \
    php82-pdo_sqlite php82-pdo php82-pcntl php82-openssl php82-opcache \
    php82-mbstring php82-intl php82-iconv php82-gettext php82-gd php82-ftp \
    php82-fileinfo php82-ffi php82-exif php82-enchant php82-dom php82-curl \
    php82-ctype php82-common php82-calendar php82-bcmath php82-pecl-redis \
    php82-pecl-imagick

RUN which php || ln -sf /usr/bin/php82 /usr/bin/php

COPY install-php-ext /usr/local/bin/install-php-ext
COPY install-php-pecl-ext /usr/local/bin/install-php-pecl-ext

#
# TARGET PHP-COMPOSER
#
FROM php_cli as php_composer

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer

#
# TARGET PHP-FPM
#
FROM php_composer as php_fpm

RUN apk add --no-cache php82-fpm
RUN which php-fpm || ln -sf /usr/sbin/php-fpm82 /usr/bin/php-fpm
RUN mkdir -p /etc/php/fpm/pool.d/

COPY php-fpm.ini /etc/php/fpm/
COPY www.ini /etc/php/fpm/pool.d/

ENTRYPOINT [ "php-fpm", "-e", "-y", "/etc/php/fpm/php-fpm.ini" ]
EXPOSE 9000

FROM php_cli