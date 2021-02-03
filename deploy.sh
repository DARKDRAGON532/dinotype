#!/usr/bin/env sh

# abort on errors
set -e

# build
npm run build

# navigate into the build output directory
cd docs

# if you are deploying to a custom domain
echo 'www.dinotype.ml' > CNAME

git add docs
git commit -m 'deploy'


cd -