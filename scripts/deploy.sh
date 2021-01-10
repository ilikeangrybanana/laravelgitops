#!/bin/sh
set -e

echo "Deploying application ..."

if [ "$1" == 'dev' ] || [ "$1" == 'test' ] || [ "$1" == 'prod' ]
then
echo "checkout $1 branch"
git checkout $1
else
echo "Enter a valid environment"
exit 1;
fi

# Enter maintenance mode
(php artisan down --message 'The app is being (quickly!) updated. Please try again in a minute.') || true
    # Update codebase
    git fetch origin $1
    git reset --hard origin/$1

    # Install dependencies based on lock file
    composer install --no-interaction --prefer-dist --optimize-autoloader

    # Migrate database
    php artisan migrate --force

    # Note: If you're using queue workers, this is the place to restart them.
    # ...

    # Clear cache
    php artisan optimize

    # Reload PHP to update opcache
    echo "" | sudo -S service php7.4-fpm reload
# Exit maintenance mode
php artisan up

echo "Application deployed!"