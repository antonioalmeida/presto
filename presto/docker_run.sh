#!/bin/bash
set -e

env >> /var/www/.env
php-fpm7.1 -D
cd /var/www
php artisan db:seed
php artisan migrate --force
nginx -g "daemon off;"
