#!/bin/sh 

set -e

mkdir -p /var/www/html
mv ./adminer.php /var/www/html/

exec "@"
