# Tutorial: Styling Angular CLI apps with Bootstrap
# https://medium.com/@beeman/tutorial-add-bootstrap-to-angular-cli-apps-b0a652f2eb2
if ! [ ${IP+x} ]; then export IP=localhost; fi
if ! [ ${PORT+x} ]; then export PORT=8080; fi
echo "IP is:" $IP " and PORT is:" $PORT
# Scaffold a new project
ng new tutorial-angular-cli-styling-bootstrap --routing --prefix MyApp
cd tutorial-angular-cli-styling-bootstrap
# Add and configure Bootstrap and FontAwesome dependencies
#npm install --save bootstrap@4.0.0-alpha.6 font-awesome
npm install --save bootstrap font-awesome
echo '@import "~bootstrap/dist/css/bootstrap.min.css";' >> src/styles.css
echo '@import "~font-awesome/css/font-awesome.css";' >> src/styles.css
ng serve --open --host $IP --port $PORT --disable-host-check
# continue changing the Angular application using the tutorial page...