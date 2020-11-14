#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

export HTTP_PROXY=user:pass@my.proxy.server:8080
export HTTPS_PROXY=user:pass@my.proxy.server:8081
export NO_PROXY=localhost,127.0.0.1,*.my.lan.domain

DEVHUB_ALIAS="dev-hub-org"
SCRATCHORG_ALIAS="temp-scratch-org"
SCRATCHORG_DURATION=5
TODAY=$(date)
CREATE_SCRATCHORG=1

echo "--> Grabbing latest version..."
LATEST_PACKAGE_ID=$(grep -m1 -o '\<04t.*\>' cicd_version_created.txt)
echo "--> Latest package version ID is:  $LATEST_PACKAGE_ID"

# Decrypt Key File
openssl enc -aes-256-cbc -md md5 -salt -d -in $PRIVATE_KEY_FILE.enc -out $PRIVATE_KEY_FILE -k $PRIVATE_KEY_PASSWORD -pbkdf2

echo "--> Connecting to Dev Hub: $DEVHUB_ALIAS ..."
sfdx force:auth:jwt:grant --clientid $DEVHUB_CONSUMER_KEY --jwtkeyfile $PRIVATE_KEY_FILE --username $DEVHUB_USERNAME --setdefaultdevhubusername  --setdefaultusername --setalias $DEVHUB_ALIAS

sfdx force:org:list > cicd_org_list.txt

echo "--> Grabbing scratch org named $SCRATCHORG_ALIAS"
SCRATCHORG_FOUND=$(grep -ic $SCRATCHORG_ALIAS cicd_org_list.txt || true)
echo "--> Number of scratch orgs found: $SCRATCHORG_FOUND"

# Create a scratch org if not there
if [ $SCRATCHORG_FOUND -eq 1 ]; then
    echo "--> Scratch Org $SCRATCHORG_ALIAS already exists"
    if [ $CREATE_SCRATCHORG -eq 1 ]; then
        echo "--> Deleting old Scratch org $SCRATCHORG_ALIAS"
        sfdx force:org:delete -p -u $SCRATCHORG_ALIAS
        echo "--> Creating new Scratch Org ..."
        sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --durationdays $SCRATCHORG_DURATION --setalias $SCRATCHORG_ALIAS --targetdevhubusername $DEVHUB_ALIAS
    fi
    echo "--> Use Following Navigation URL..."
    sfdx force:org:open --targetusername $SCRATCHORG_ALIAS --urlonly
else
    echo "--> Creating Scratch Org..."
    sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --durationdays $SCRATCHORG_DURATION --setalias $SCRATCHORG_ALIAS --targetdevhubusername $DEVHUB_ALIAS
    echo "--> Use Following Navigation URL..."
    sfdx force:org:open --targetusername $SCRATCHORG_ALIAS --urlonly
fi

echo "--> Auth List"
sfdx force:auth:list

# Get the username for the scratch org
SCRATCH_ORG_USERNAME="$(eval sfdx force:user:display --json | jq -r '.result.username')"
echo "$SCRATCH_ORG_USERNAME" > ./cicd_user_display.txt
# Generate a new password for the scrach org
sfdx force:user:password:generate
# Display username, password, and instance URL for login
sfdx force:user:display

echo "--> This scratch org URL will be available for the next $SCRATCHORG_DURATION days starting this $TODAY"

echo "--> Intalling package version ID - $LATEST_PACKAGE_ID to Org - $SCRATCHORG_ALIAS"
sfdx force:package:install --wait 10 --publishwait 10 --package $LATEST_PACKAGE_ID --installationkey $PACKAGE_KEY_PASS --noprompt --targetusername $SCRATCHORG_ALIAS --loglevel info

echo "--> Deploying Metadata API code into - $SCRATCHORG_ALIAS"
sfdx force:mdapi:deploy --deploydir mdapioutput/ --targetusername $SCRATCHORG_ALIAS --wait 100
