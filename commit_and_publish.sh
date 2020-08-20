#!/bin/bash

# Build new files
echo "-----------------Building new files"
cabal new-run site clean
cabal new-run site build

# Copy files to publishing directory
cp -R _site/* docs

# commit to develop branch, probably uneccessary?
echo "-----------------Commiting to develop branch"
git add -A

if [ "$1" != "" ]; then
	git commit -m "$1"
else
	git commit -m "dev update"
fi

git push origin develop