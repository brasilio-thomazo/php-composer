FROM alpine:latest

ENV EXTS=""
ENV PECL_EXTS=""

RUN apk add --no-cache --no-interactive bash icu-data-full php82 php82-zip \
    php82-xsl php82-xmlwriter php82-xmlreader php82-xml php82-tokenizer \
    php82-tidy php82-sysvshm php82-sysvsem php82-sysvmsg php82-sodium \
    php82-sockets php82-bz2 php82-simplexml php82-session php82-phar php82-pear \
    php82-pdo_sqlite php82-pdo php82-pcntl php82-openssl php82-opcache \
    php82-mbstring php82-intl php82-iconv php82-gettext php82-gd php82-ftp \
    php82-fileinfo php82-ffi php82-exif php82-enchant php82-dom php82-curl \
    php82-ctype php82-common php82-calendar php82-bcmath \
    $(echo "${EXTS}" | awk -F ' ' '{for(i=1;i<=NF;i++) print "php82-"$i}') \
    php81-pecl-redis php81-pecl-imagick \
    $(echo "${PECL_EXTS}" | awk -F ' ' '{for(i=1;i<=NF;i++) print "php82-pecl-"$i}')
RUN which php || ln -sf /usr/bin/php82 /usr/bin/php
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer

COPY policy.xml /etc/ImageMagick-7/policy.xml