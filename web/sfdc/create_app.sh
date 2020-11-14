# https://trailhead.salesforce.com/content/learn/modules/sfdx_app_dev/sfdx_app_dev_create_app
cd apps
# Create a Salesforce DX Project
sfdx force:project:create -n geolocation
cd geolocation
# Optional: Authorize a default Developer Hub (Dev Hub) org
sfdx force:auth:web:login --setdefaultdevhubusername --setalias TestDevHub
# Create a Scratch Org
sfdx force:org:create -s -f config/project-scratch-def.json -a GeoAppScratch --targetdevhubusername TestDevHub
# Create Sample Data: new records in Account object
sfdx force:data:record:create -s Account -v "Name='Marriott Marquis' BillingStreet='780 Mission St' BillingCity='San Francisco' BillingState='CA' BillingPostalCode='94103' Phone='(415) 896-1600' Website='www.marriott.com'"
sfdx force:data:record:create -s Account -v "Name='Hilton Union Square' BillingStreet='333 O Farrell St' BillingCity='San Francisco' BillingState='CA' BillingPostalCode='94102' Phone='(415) 771-1400' Website='www.hilton.com'"
sfdx force:data:record:create -s Account -v "Name='Hyatt' BillingStreet='5 Embarcadero Center' BillingCity='San Francisco' BillingState='CA' BillingPostalCode='94111' Phone='(415) 788-1234' Website='www.hyatt.com'"
# In your Salesforce DX geolocation project, create a directory called data
mkdir data
# Export some sample data
# For testing purpose we provide commands to easily grab data from your scratch org and pull it into your projec
sfdx force:data:tree:export -q "SELECT Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, Phone, Website FROM Account WHERE BillingStreet != NULL AND BillingCity != NULL and BillingState != NULL" -d ./data
# You now have sample data that you can import in the future with the command.
sfdx force:data:tree:import --sobjecttreefiles data/Account.json
# In case you need to remove the scratch org:
# $ sfdx force:org:delete -u GeoAppScratch
