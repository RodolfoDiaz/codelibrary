# Based on Pluralsight course
# https://app.pluralsight.com/library/courses/two-tier-enterprise-app-api-development-angular-sails/
if [ -d ./socialfleet/ ]; then echo "socialfleet folder already created"; else ./socialfleet.sh; fi
cd socialfleet
if [ -d ./frontend/ ]; then rm -rf frontend; fi
mkdir frontend
cd frontend
# Init package.json file; only defaults and not prompt you for any options.
npm init --force
npm install bower --save-dev
# Init bower.json file. There is no built-in option for 
# bower init to execute silently, but the unix yes command will work.
yes '' | bower init
bower install angular --save