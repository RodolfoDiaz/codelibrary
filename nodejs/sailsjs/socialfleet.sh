# Based on Pluralsight course
# https://app.pluralsight.com/library/courses/two-tier-enterprise-app-api-development-angular-sails/
if [ -d ./socialfleet/ ]; then rm -rf socialfleet; fi
npm install sails -g
mkdir socialfleet
cd socialfleet
sails new backend
cd backend
sails lift
# browse to http://localhost:1337
# Press key CTRL-C to exit Sails process
sails generate api user
sails lift
# browse to http://localhost:1337/user
# --> now, let's create a new user:
# browse to http://localhost:1337/user/create?name=Rodolfo
# browse to http://localhost:1337/user/create?name=Rodolfo%20Díaz&email=rodolfo@mail.com
# --> Get all users created
# browse to http://localhost:1337/user
# --> Find certain user
# browse to http://localhost:1337/user?id=2
# browse to http://localhost:1337/user?name=Rodolfo