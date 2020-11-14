#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

export HTTP_PROXY=user:pass@my.proxy.server:8080
export HTTPS_PROXY=user:pass@my.proxy.server:8081
export NO_PROXY=localhost,127.0.0.1,*.my.lan.domain

DEVHUB_ALIAS="dev-hub-org"

echo "--> Logout of all Orgs"
sfdx force:auth:logout --all --noprompt

# Decrypt Key File
openssl enc -aes-256-cbc -md md5 -salt -d -in $PRIVATE_KEY_FILE.enc -out $PRIVATE_KEY_FILE -k $PRIVATE_KEY_PASSWORD -pbkdf2

# Login to the Dev Hub
echo "--> Connecting to Dev Hub: $DEVHUB_ALIAS ..."
sfdx force:auth:jwt:grant --clientid $DEVHUB_CONSUMER_KEY --jwtkeyfile $PRIVATE_KEY_FILE --username $DEVHUB_USERNAME --setdefaultdevhubusername  --setdefaultusername --setalias $DEVHUB_ALIAS

echo "--> Org List"
sfdx force:org:list --all
echo "--> Config List"
sfdx force:config:list

# Display org info
echo "--> Display $DEVHUB_ALIAS info..."
sfdx force:org:display --targetusername $DEVHUB_ALIAS

# List packages
sfdx force:package:list --targetdevhubusername $DEVHUB_ALIAS > cicd_package_list.txt

echo "--> Grabbing package named: $PACKAGE_NAME"
PACKAGE_FOUND=$(grep -ic $PACKAGE_NAME cicd_package_list.txt || true)
echo "--> Packages found in Dev Hub: $PACKAGE_FOUND"

# Create the unlocked package if needed
if [ $PACKAGE_FOUND -eq 1 ]; then
    echo "--> $PACKAGE_NAME package already exists, no need to recreate."
    echo "--> Display packages stored in $DEVHUB_ALIAS"
    sfdx force:package:list --targetdevhubusername $DEVHUB_ALIAS
else
    echo "--> Creating package ..."
    sfdx force:package:create --name $PACKAGE_NAME --description $PACKAGE_DESCRIPTION --packagetype Unlocked --path force-app --nonamespace --targetdevhubusername $DEVHUB_ALIAS
fi

# Custom-Profiles and Sharing Rules are not supported by standard Unlocked Packaging API
# https://developer.salesforce.com/docs/metadata-coverage/48
echo "--> Preparing the files to be deployed through MetaData API"
rm -rf ./unpackaged
mkdir unpackaged
mkdir unpackaged/profiles
cp force-app/main/default/profiles unpackaged/profiles
mkdir unpackaged/profilePasswordPolicies
cp force-app/main/default/profilePasswordPolicies unpackaged/profilePasswordPolicies
mv force-app/main/default/sharingRules/ unpackaged/
cp -r force-app/main/default/reports/ unpackaged/
echo "--> Converting code from unpackaged folder to Metadata API output folder (mdapioutput)"
sfdx force:source:convert --outputdir ./mdapioutput/ --rootdir ./unpackaged

# Code Coverage for Unlocked Packages: a minimum 75% code coverage is required for package version promotion.
echo "--> Creating new package version. Package name: $PACKAGE_NAME - Dev Hub: $DEVHUB_ALIAS - Username: $DEVHUB_USERNAME"
sfdx force:package:version:create --package $PACKAGE_NAME --path force-app --installationkey $PACKAGE_KEY_PASS --codecoverage --wait 20 --targetdevhubusername $DEVHUB_ALIAS --loglevel debug > cicd_version_created.txt

sfdx force:package:version:list --targetdevhubusername $DEVHUB_ALIAS --packages $PACKAGE_NAME > cicd_version_list.txt

LATEST_PACKAGE_ID=$(grep -m1 -o '\<04t.*\>' ./cicd_version_created.txt)
sfdx force:package:version:report --targetdevhubusername $DEVHUB_ALIAS --package=$LATEST_PACKAGE_ID --json > cicd_version_report.json
PACKAGE_VERSION="$(eval cat cicd_version_report.json | jq -r '.result.Version')"

echo "--> New package created: $PACKAGE_NAME Version $PACKAGE_VERSION"
cat cicd_version_report.json

echo "--> Creating a tag. It's a pointer to a specific commit / release version"
git config user.email "${GITLAB_USER_EMAIL}"
git config user.name "${GITLAB_USER_NAME}"
git remote add tag-origin https://oauth2:${GITLAB_ACCESS_TOKEN}@gitlab.com/myaccount/myproject/myproject.git
git tag -a "$PACKAGE_VERSION-$LATEST_PACKAGE_ID" -m "Date: $(date +%Y-%m-%d_%T)"
git push tag-origin "$PACKAGE_VERSION-$LATEST_PACKAGE_ID"
