#!/bin/bash



# Verify correct branch
git checkout develop

#Run tag fixer
python tag-fixer.py

#Recompile site.hs
stack build

# Build new files
echo "-----------------Building new files"
stack exec github-page rebuild

# commit to develop branch, probably uneccessary?
echo "-----------------Commiting to develop branch"
git add -A

if [ "$1" != "" ]; then
	git commit -m "$1"
else
	git commit -m "dev update"
fi

git push origin develop

# Get previous files
echo "-----------------Fetching and checking out to master"
git fetch --all
git checkout -b master --track origin/master

# Overwrite existing files with new files
echo "-----------------Writing new files"
yes | cp -a -f _site/. .

git checkout master
# Commit
echo "-----------------Committing to master"
git add -A

if [ "$1" != "" ]; then
	git checkout master
	git commit -m "$1"
else
	git checkout master
	git commit -m "publishing"
fi

# Push
echo "-----------------Push"
git push origin master #master:master

# Restoration
echo "-----------------Restoring to original state"
git checkout develop
git branch -D master

#git stash pop