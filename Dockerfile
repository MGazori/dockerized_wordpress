FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    gifsicle \
    jpegoptim \
    libonig-dev \
    locales \
    optipng \
    pngquant \
    libmpc-dev \
    unzip \
    vim \
    libfreetype6-dev \
    libmagickwand-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libzip-dev \
    jpegoptim \
    optipng \
    gifsicle \
    git-core \
    build-essential \
    openssl \
    libssl-dev \
    libonig-dev \
    zip \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install gettext \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-enable mysqli \
    && pecl install xdebug-beta \
        imagick \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-enable imagick \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ioncube loader
RUN curl -fSL 'http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz' -o ioncube.tar.gz \
    && mkdir -p ioncube \
    && tar -xf ioncube.tar.gz -C ioncube --strip-components=1 \
    && rm ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_8.2.so /var/ioncube_loader_lin_8.2.so \
    && rm -r ioncube

# php.ini
RUN echo 'zend_extension = /var/ioncube_loader_lin_8.2.so' > /usr/local/etc/php/php.ini

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl gd gmp \
    && docker-php-ext-configure gd --with-freetype --with-jpeg

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Start php-fpm server
CMD ["php-fpm"]
