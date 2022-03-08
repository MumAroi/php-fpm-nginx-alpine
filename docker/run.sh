#!/bin/sh

cd /var/www/html/you-project

# php artisan migrate:fresh --seed
php artisan cache:clear
php artisan route:cache

/usr/bin/supervisord -c /etc/conf.d/supervisord.conf