#!/bin/bash

set -e

echo HOME: $HOME
echo GITHUB_WORKFLOW: $GITHUB_WORKFLOW
echo GITHUB_RUN_ID: $GITHUB_RUN_ID
echo GITHUB_RUN_NUMBER: $GITHUB_RUN_NUMBER
echo GITHUB_ACTION: $GITHUB_ACTION
echo GITHUB_ACTIONS: $GITHUB_ACTIONS
echo GITHUB_ACTOR: $GITHUB_ACTOR
echo GITHUB_REPOSITORY: $GITHUB_REPOSITORY
echo GITHUB_EVENT_NAME: $GITHUB_EVENT_NAME
echo GITHUB_EVENT_PATH: $GITHUB_EVENT_PATH
echo GITHUB_WORKSPACE: $GITHUB_WORKSPACE
echo GITHUB_SHA: $GITHUB_SHA
echo GITHUB_REF: $GITHUB_REF
echo GITHUB_HEAD_REF: $GITHUB_HEAD_REF
echo GITHUB_BASE_REF: $GITHUB_BASE_REF

BRANCH_TO_MERGE=$(echo ${GITHUB_REF} | sed -e "s/refs\/heads\///g")
echo BRANCH: $BRANCH_TO_MERGE

REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

echo REPO_FULLNAME: $REPO_FULLNAME
echo GITHUB_TOKEN: $GITHUB_TOKEN

git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$REPO_FULLNAME.git

git config --global user.email "actions@github.com"
git config --global user.name "Gh-pages Merge Action"

set -o xtrace

echo Start fetch

git fetch origin gh-pages

echo End fetch

echo Start checkout

git checkout -b gh-pages origin/gh-pages

echo End checkout

echo Start merge

git merge origin/$BRANCH_TO_MERGE --allow-unrelated-histories --no-edit

echo End merge

echo Start push

git push origin gh-pages

echo End push

echo DONE !!!!
