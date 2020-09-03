#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

export HTTP_PROXY=user:pass@my.proxy.server:8080
export HTTPS_PROXY=user:pass@my.proxy.server:8081
export NO_PROXY=localhost,127.0.0.1,*.my.lan.domain

# Set values depending on the Salesforce environments you have
# Options: sandbox, devint1, qa1, bench, prod
if [ "$1" == "sandbox" ]; then
    SERVER_CONSUMER_KEY=$SANDBOX_CONSUMER_KEY
    SERVER_USERNAME=$SANDBOX_USERNAME
elif [ "$1" == "devint1" ]; then
    SERVER_CONSUMER_KEY=$DEVINT_SERVER_CONSUMER_KEY
    SERVER_USERNAME=$DEVINT_SERVER_USERNAME
elif [ "$1" == "qa1" ]; then
    SERVER_CONSUMER_KEY=$QA_SERVER_CONSUMER_KEY
    SERVER_USERNAME=$QA_SERVER_USERNAME
elif [ "$1" == "bench" ]; then
    SERVER_CONSUMER_KEY=$BENCH_SERVER_CONSUMER_KEY
    SERVER_USERNAME=$BENCH_SERVER_USERNAME
elif [ "$1" == "prod" ]; then
    SERVER_CONSUMER_KEY=$PROD_SERVER_CONSUMER_KEY
    SERVER_USERNAME=$PROD_SERVER_USERNAME
else
    echo "--> Environment not found: $1"
    exit 1
fi

SERVER_ALIAS="$1-server-org"

if [ "$1" == "prod" ]; then
    SERVER_KEY_FILE=$PRIVATE_KEY_PROD_FILE
    SERVER_KEY_PASSWORD=$PRIVATE_KEY_PROD_PASSWORD
else
    SERVER_KEY_FILE=$PRIVATE_KEY_FILE
    SERVER_KEY_PASSWORD=$PRIVATE_KEY_PASSWORD
fi

# Decrypt Key File
openssl enc -aes-256-cbc -md md5 -salt -d -in $SERVER_KEY_FILE.enc -out $SERVER_KEY_FILE -k $SERVER_KEY_PASSWORD -pbkdf2

echo "--> Connecting to Salesforce Org alias: $SERVER_ALIAS ..."
if [ "$1" == "prod" ]; then
    sfdx force:auth:jwt:grant --clientid $SERVER_CONSUMER_KEY --jwtkeyfile $SERVER_KEY_FILE --username $SERVER_USERNAME --setdefaultdevhubusername --setdefaultusername --setalias $SERVER_ALIAS --instanceurl https://login.salesforce.com
else
    sfdx force:auth:jwt:grant --clientid $SERVER_CONSUMER_KEY --jwtkeyfile $SERVER_KEY_FILE --username $SERVER_USERNAME --setdefaultdevhubusername --setdefaultusername --setalias $SERVER_ALIAS --instanceurl https://test.salesforce.com
fi

echo "--> Org Display"
sfdx force:org:display --targetusername $SERVER_ALIAS

echo "--> Auth List"
sfdx force:auth:list

echo "--> Grabbing latest version..."
LATEST_PACKAGE_ID=$(grep -m1 -o '\<04t.*\>' ./cicd_version_created.txt)
echo "--> Latest package version ID is - $LATEST_PACKAGE_ID"
PACKAGE_VERSION="$(eval cat cicd_version_report.json | jq -r '.result.Version')"

if [ "$1" == "prod" ]; then
    echo "--> Promote the package version: $PACKAGE_VERSION - $LATEST_PACKAGE_ID"
    sfdx force:package:version:promote --package $LATEST_PACKAGE_ID --noprompt
    sfdx force:package:version:report --package $LATEST_PACKAGE_ID  --json > cicd_version_report_promote.json
    cat cicd_version_report_promote.json
fi

echo "--> Intalling package version ID - $LATEST_PACKAGE_ID to - $SERVER_ALIAS"
sfdx force:package:install --wait 10 --publishwait 10 --package $LATEST_PACKAGE_ID --installationkey $PACKAGE_KEY_PASS --noprompt --targetusername $SERVER_ALIAS --loglevel info

echo "--> Deploying Metadata API code into - $SERVER_ALIAS"
sfdx force:mdapi:deploy --deploydir mdapioutput/ --targetusername $SERVER_ALIAS --wait 100
