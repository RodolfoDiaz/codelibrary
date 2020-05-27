# https://trailhead.salesforce.com/en/content/learn/modules/apex_testing/
cd apps
# Create a Salesforce DX Project
sfdx force:project:create -n MyTestApp
# Change directory
cd MyTestApp
# Authorize a default Developer Hub (Dev Hub) org
# Optional:  --setdefaultdevhubusername
sfdx force:auth:web:login --setalias TestDevHub
# Check the Orgs available (TestDevHub)
sfdx force:org:list
# Create scratch org
sfdx force:org:create --setalias TestScratchOrg --setdefaultusername --definitionfile config/project-scratch-def.json --targetdevhubusername TestDevHub
# Check the configuration (defaultusername)
sfdx force:config:list
# Open the scratch org you just created.
sfdx force:org:open -u TestScratchOrg
# Create Class TemperatureConverter
sfdx force:apex:class:create --classname TemperatureConverter --outputdir force-app/main/default/classes
# Add class code from TH module!
# Create Class TemperatureConverterTest
sfdx force:apex:class:create --classname TemperatureConverterTest --outputdir force-app/main/default/classes
# Add test code from TH module!
# Push the local metadata to the scratch org
sfdx force:source:push --targetusername TestScratchOrg
# Pull the changes from your scratch org to your local project
sfdx force:source:pull --targetusername TestScratchOrg
# Run Apex Tests
sfdx force:apex:test:run --wait 10 --resultformat json --codecoverage --testlevel RunLocalTests --json
# Remove the scratch org:
sfdx force:org:delete -u TestScratchOrg
# Logout from Dev Hub:
sfdx force:auth:logout --targetusername TestDevHub --noprompt
# Logout all
sfdx force:auth:logout --all --noprompt