#!/bin/bash
set -e

git clone $REPOSITORY project
git cd project
git checkout master
cp -r www/* /var/www/html

exec "$@"