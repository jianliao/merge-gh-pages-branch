#!/bin/bash

set -e

BRANCH_TO_MERGE=$(echo ${GITHUB_REF} | sed -e "s/refs\/heads\///g")
REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

echo Setup...

git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$REPO_FULLNAME.git
git config --global user.email "actions@github.com"
git config --global user.name "Github Gh-pages Merge Action"

git remote -v

# set -o xtrace

echo Fetch ....
git fetch origin

git checkout -b gh-pages origin/gh-pages

git merge origin/$BRANCH_TO_MERGE --allow-unrelated-histories --no-edit

git push origin gh-pages
