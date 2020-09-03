#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

export HTTP_PROXY=user:pass@my.proxy.server:8080
export HTTPS_PROXY=user:pass@my.proxy.server:8081
export NO_PROXY=localhost,127.0.0.1,*.my.lan.domain

# Initial setup:
# 1- Grant access to the faceless account used for Continuous Integration with Developer role in your GitLab project.
# 2- Log in as the faceless account, open the profile Settings page, under Access Tokens option. 
#    After a click on “Create personal access token”, the token is shown only once (on top of the page).
# 3- The username, email and token are stored in Project settings - CI / CD, in the Variables settings.
git config user.email "${GITLAB_USER_EMAIL}"
git config user.name "${GITLAB_USER_NAME}"
git remote add cicd-origin https://oauth2:${GITLAB_ACCESS_TOKEN}@gitlab.com/myaccount/myproject/myproject.git

SOURCE_BRANCH=$1
TARGET_BRANCH=$2

git fetch cicd-origin

echo "--> Merging code from $SOURCE_BRANCH into $TARGET_BRANCH"
git checkout cicd-origin/$TARGET_BRANCH
# Git Merge using Resolve strategy
git merge -s resolve cicd-origin/$SOURCE_BRANCH -m "CI/CD - Auto-merge"
git push cicd-origin HEAD:$TARGET_BRANCH
