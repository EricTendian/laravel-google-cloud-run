FROM composer:latest AS composer

COPY composer.json composer.lock ./

# Install all Composer packages
RUN composer install --no-interaction --prefer-dist \
# We are adding these two arguments so we can have composer install cached
# See https://www.sentinelstand.com/article/composer-install-in-dockerfile-without-breaking-cache
    --no-scripts --no-autoloader

COPY . ./

# Run commands that generate unique files every time
RUN composer dump-autoload --optimize

FROM erictendian/phppm-nginx:latest

COPY . ./

COPY --from=composer /app/vendor ./vendor/

CMD ["--bootstrap=laravel", "--static-directory=public/"]
