# https://hub.docker.com/r/salesforce/salesforcedx
if [ "$1" == "up" ]; then
    docker pull salesforce/salesforcedx:latest-full
    docker image ls -a
    docker container ls -a
    # Create a new salesforcedx container
    docker run --name sfdx_container1 --detach -it salesforce/salesforcedx:latest-full
    #docker start sfdx_container1
elif [ "$1" == "down" ];  then
    echo 'Stop and remove the container'
    docker stop sfdx_container1
    docker rm sfdx_container1
elif [ "$1" == "bash" ];  then
    # start a bash session to the container
    docker exec -it sfdx_container1 bin/bash
    # You can also execute a command:
    # docker exec -it sfdx_container1 sfdx version
fi
