#!/bin/bash
set -e

env >> /var/www/.env
php-fpm7.1 -D
php artisam migrate --force
nginx -g "daemon off;"
