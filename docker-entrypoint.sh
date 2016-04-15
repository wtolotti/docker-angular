#!/bin/bash
set -e

git clone $REPOSITORY project
cd project
git checkout master
rm -f index.html
cp -r www/* /var/www/html

exec "$@"
