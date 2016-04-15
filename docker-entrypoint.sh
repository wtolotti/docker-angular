#!/bin/bash
set -e

git clone $REPOSITORY project
cd project
git checkout master
cp -r www/* /var/www/html

exec "$@"