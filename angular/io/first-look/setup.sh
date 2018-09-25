if ! [ ${IP+x} ]; then export IP=localhost; fi
if ! [ ${PORT+x} ]; then export PORT=8080; fi
rm -rf ./angular-first-look-hosted
git clone https://github.com/johnpapa/angular-first-look-hosted.git
cd angular-first-look-hosted
npm install
ng serve --open --host $IP --port $PORT --disable-host-check