if ! [ ${IP+x} ]; then export IP=localhost; fi
if ! [ ${PORT+x} ]; then export PORT=8080; fi
echo "IP is:" $IP " and PORT is:" $PORT
if ! [ -d ./node_modules/ ]; then echo Installing Dependencies; npm install; fi
npm start