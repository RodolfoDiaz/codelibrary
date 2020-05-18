# Convert and Deploy an Existing App
cd apps
# Create a project called MutualFundExplorer
sfdx force:project:create -n MutualFundExplorer
cd MutualFundExplorer
# Config default Dev Hub org
sfdx force:config:set defaultdevhubusername=TestDevHub
# Create a scratch org with the alias TempUnmanaged
sfdx force:org:create -f config/project-scratch-def.json -a TempUnmanaged
# View the configuration data for the scratch org
sfdx force:org:display -u TempUnmanaged
# Create a password
sfdx force:user:password:generate -u TempUnmanaged
# Reissue the org:display command to see all the required values to install the package
sfdx force:org:display -u TempUnmanaged

# Install the Unmanaged Package
# With the username, password, and instance URL, you can now log in to the UI for 
# installing the unmanaged package for the Mutual Fund Explorer app, which is called DreamInvest.
# Browse to the following URL (in Incognito mode)
# https://login.salesforce.com/packaging/installPackage.apexp?p0=04t46000001DnYm
# In the login screen, click Use Custom Domain
# copy the Instance Url without https:// (from the Org Description provided by previous command)

# Create the Permission Set
# New Permission Set, Name: DreamInvest
# Add Assigned Apps, Name: DreamInvest (DreamInvest)

# Extract this permission set into our source
sfdx force:source:pull -u TempUnmanaged

# Extract the Package Source to Your Project
# Retrieve the contents of the DreamInvest package into the mdapipackage folder:
sfdx force:mdapi:retrieve -s -r ./mdapipackage -p DreamInvest -u TempUnmanaged -w 10
cd mdapipackage
unzip unpackaged.zip
rm unpackaged.zip
cd ..

# Convert the Source and Push It to a New Scratch Org
# From the MutualFundExplorer folder, convert the contents of the mdapipackage folder
sfdx force:mdapi:convert -r mdapipackage/
# Clean up your project by deleting the Metadata API source:
rm -rf mdapipackage
# Delete the scratch org
sfdx force:org:delete -u TempUnmanaged

# Verify Your Work
sfdx force:org:create -s -f config/project-scratch-def.json
# Notice the command sets this new scratch org to be the default for this project. 
# This way, any commands you issue are run against this scratch org.
# Push your local source and metadata to the scratch org
sfdx force:source:push
# Assign a permission set
sfdx force:user:permset:assign -n DreamInvest 
# Open your org
sfdx force:org:open

# Deploy the Converted App Using Metadata API
# Register Your Testing Environment
sfdx force:auth:web:login -a MyTP
# Confirm that this org is available
sfdx force:org:list

# Convert Source to Metadata Format and Deploy
# Create a folder to put the converted files called mdapioutput.
mkdir mdapioutput
sfdx force:source:convert -d mdapioutput/
# Deploy it to your testing environment
sfdx force:mdapi:deploy -d mdapioutput/ -u MyTP -w 100
# Assign a permission set
sfdx force:user:permset:assign -n DreamInvest -u MyTP
# Run your tests and interact with the app
sfdx force:org:open -u MyTP
# You’ve just walked through a large chunk of the package development life cycle. 
# You created an app, converted an existing app, and deployed the app to an org.
