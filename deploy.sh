#!/usr/bin/env sh

# abort on errors
set -e

# build
npm run build

# navigate into the build output directory
cd docs

# if you are deploying to a custom domain
echo 'www.dinotype.ml' > CNAME
cd -
git add .
git commit -m 'deploy'
git push --force


