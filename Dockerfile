FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev \
    g++ \
    nodejs \
    npm

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy existing application directory contents
COPY . .

# Install PHP dependencies
RUN composer install --prefer-dist --no-scripts --no-dev --optimize-autoloader

# Install Node.js dependencies
RUN npm install

# Build assets
RUN npm run prod

# Expose port 8090 and start the application
CMD php artisan serve --host=0.0.0.0 --port=8090
EXPOSE 8090
