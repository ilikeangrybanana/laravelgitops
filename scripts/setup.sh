#!/bin/bash
set -e

echo "Setting up application ..."

if [ "$1" == 'dev' ] || [ "$1" == 'test' ] || [ "$1" == 'prod' ]
then
echo "checkout $1 branch"
git checkout $1
else
echo "Enter a valid environment"
exit 1;
fi

echo "installing composer dependencies"
composer install -no-interaction --prefer-dist --optimize-autoloader

# this setp should be handled by configuration manager
echo "copy .env file"
cp .env.example .env

echo "migrate db"
php artisan migrate --force

echo "optimizing app"
php artisan optimize

echo "Application Setup successfully"