#!/bin/bash
set -e

git clone $REPOSITORY project
cd project
git checkout master
cp -r www/* /var/www/html
rm -f /var/www/html/index.html

exec "$@"
