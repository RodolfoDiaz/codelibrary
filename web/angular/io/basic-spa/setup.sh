# Angular CLI - https://github.com/angular/angular-cli
# Updating Angular CLI (uncomment the next two lines to uninstall and clear cache, before you re-install the latest)
#npm uninstall -g @angular/cli
#npm cache clean --force
# Install Angular CLI
npm install -g @angular/cli@latest
# Verify the installation (two methods)
npm list -g @angular/cli --depth=0
ng -v
# Generating the Angular application
ng new route-test --routing
cd route-test
ng g component home
ng g component about
ng g component news
