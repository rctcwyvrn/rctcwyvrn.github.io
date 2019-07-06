#!/bin/bash

# Temporarily store uncommited changes
#git stash

# Verify correct branch
git checkout develop

# Build new files
echo "-----------------Building new files"
stack exec github-page clean
stack exec github-page build

# commit to develop branch, probably uneccessary?
# echo "-----------------Commiting to develop branch"
# git add -A
# git commit -m $1

# Get previous files
echo "-----------------Fetching and checking out to master"
git fetch --all
git checkout -b master --track origin/master

# Overwrite existing files with new files
echo "-----------------Writing new files"
yes | cp -a -f _site/. .

# Commit
echo "-----------------Committing to master"
git add -A

if [ "$1" != "" ]; then
	git commit -m "$1"
else
	git commit -m "publishing"
fi

# Push
echo "-----------------Push"
git push origin master:master

# Restoration
echo "-----------------Restoring to original state"
git checkout develop
git branch -D master

#git stash pop