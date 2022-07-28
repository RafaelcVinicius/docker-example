FROM php:8.1.1-fpm

# Set working directory
WORKDIR /var/www/

# Arguments
ARG user=rafael
ARG uid=1000

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user
    
USER $user

# 
# Frontend
# 

FROM node:14.18 as frontend

WORKDIR /var/www/

COPY artisan package.json .env ./

RUN yarn install

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 8000