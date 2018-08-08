if ! [ ${IP+x} ]; then export IP=localhost; fi
if ! [ ${PORT+x} ]; then export PORT=8080; fi
echo "IP is:" $IP " and PORT is:" $PORT
cd route-test
ng serve --open --host $IP --port $PORT --disable-host-check
# The "--disable-host-check" flag is used as workaround if your execute from Cloud9,
# to disable the validation of allowed hosts.  Avoid this flag if possible.
