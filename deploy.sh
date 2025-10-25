#!/usr/bin/env sh

set -e

npm run build

cd dist

git init
git add -A
git commit -m 'deploy'

#https://yaminye.github.io/My-Web/
git push -f https://github.com/Yaminye/My-Web.git master:gh-pages

cd -