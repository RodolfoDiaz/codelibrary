#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

export HTTP_PROXY=user:pass@my.proxy.server:8080
export HTTPS_PROXY=user:pass@my.proxy.server:8081
export NO_PROXY=localhost,127.0.0.1,*.my.lan.domain

DEVHUB_ALIAS="dev-hub-org"
SCRATCHORG_ALIAS="unit-test-scratch-org"
SCRATCHORG_DURATION=1

echo "--> Logout of all Orgs"
sfdx force:auth:logout -a -p

# Decrypt Key File
openssl enc -aes-256-cbc -md md5 -salt -d -in $PRIVATE_KEY_FILE.enc -out $PRIVATE_KEY_FILE -k $PRIVATE_KEY_PASSWORD -pbkdf2

echo "--> Connecting to Dev Hub: $DEVHUB_ALIAS ..."
sfdx force:auth:jwt:grant --clientid $DEVHUB_CONSUMER_KEY --jwtkeyfile $PRIVATE_KEY_FILE --username $DEVHUB_USERNAME --setdefaultdevhubusername  --setdefaultusername --setalias $DEVHUB_ALIAS

echo "--> Org List"
sfdx force:org:list --all

echo "--> Creating Scratch Org..."
sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --durationdays $SCRATCHORG_DURATION --setalias $SCRATCHORG_ALIAS --targetdevhubusername $DEVHUB_ALIAS

sfdx force:org:display

echo "--> Config List"
sfdx force:config:list

echo "--> Push source code changes into the Scratch Org..."
sfdx force:source:push --targetusername $SCRATCHORG_ALIAS

echo "--> Assing Permission Set Group to the default user..."
sfdx force:user:permset:assign --permsetname CMSSN_Office --targetusername $SCRATCHORG_ALIAS

echo "--> Invoke Apex tests..."
# Adding the " || true" at the end of this command let the script continue after a failed test run
sfdx force:apex:test:run --wait 10 --resultformat json --codecoverage --testlevel RunAllTestsInOrg --json > cicd_test_run.json || true
TEST_OUTCOME="$(eval cat cicd_test_run.json | jq -r '.result.summary.outcome')"
TESTS_RAN="$(eval cat cicd_test_run.json | jq -r '.result.summary.testsRan')"
TESTS_PASSED="$(eval cat cicd_test_run.json | jq -r '.result.summary.passRate')"
TEST_RUN_COVERAGE="$(eval cat cicd_test_run.json | jq -r '.result.summary.testRunCoverage')"
ORG_WIDE_COVERAGE="$(eval cat cicd_test_run.json | jq -r '.result.summary.orgWideCoverage')"

echo "--> Delete Scratch Org $SCRATCHORG_ALIAS"
sfdx force:org:delete --targetusername $SCRATCHORG_ALIAS --noprompt

if [ "$TEST_SUCCESS_REQUIRED" == "1" ]; then
  if [ "$TEST_OUTCOME" == "Failed" ]; then
    cat cicd_test_run.json
    EXIT_CODE=1
  else
    EXIT_CODE=0
  fi
else
  echo "--> Test result validation was skipped"
  EXIT_CODE=0
fi

echo "--> Apex Test result was: $TEST_OUTCOME"
echo "--> $TESTS_RAN tests executed, $TESTS_PASSED passed, with Test Run coverage of $TEST_RUN_COVERAGE and Org-Wide coverage rate $ORG_WIDE_COVERAGE."
# Return exit code based on test outcome
exit $EXIT_CODE
