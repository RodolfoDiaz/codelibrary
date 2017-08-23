# Angular CLI - https://github.com/angular/angular-cli
if ! [ ${IP+x} ]; then export IP=localhost; fi
if ! [ ${PORT+x} ]; then export PORT=8080; fi
echo "IP is:" $IP " and PORT is:" $PORT
# Updating Angular CLI (uncomment the next two lines to uninstall and clear cache, before you re-install the latest)
#npm uninstall -g @angular/cli
#npm cache clean --force
# Install Angular CLI
npm install -g @angular/cli@latest
# Verify the installation (two methods)
npm list -g @angular/cli --depth=0
ng -v
# Generating and serving an Angular project via a development server
ng new my-app
cd my-app
ng serve --open --host $IP --port $PORT --disable-host-check
# The "--disable-host-check" flag is used as workaround if your execute from Cloud9,
# to disable the validation of allowed hosts.  Avoid this flag if possible.
