#!/bin/bash

set -ev

TARGET_BRANCH=feature/travis-builds

git config --global user.email "travis@travis-ci.com"
git config --global user.name "Travis CI"

git checkout $TARGET_BRANCH

python $TRAVIS_BUILD_DIR/.travis/bump_version.py package.json package-lock.json

VERSION=$(cat package.json | jq -r ".version")

git add .
git commit -m "$VERSION_BUMP_MESSAGE_PREFIX $VERSION"

#git tag -a $VERSION -m "$VERSION"

git remote add origin-authenticated https://${GITHUB_TOKEN}@github.com/$GIT_REPO_SLUG.git
git push --set-upstream origin-authenticated --follow-tags $TARGET_BRANCH
