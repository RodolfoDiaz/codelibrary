# https://hub.docker.com/_/mariadb
if [ "$1" == "up" ]; then
    docker pull mariadb:latest
    docker image ls -a
    docker container ls -a
    # Create a new MariaDB container
    docker run -p 3306:3306 --name mariadb_container1 -e MARIADB_DATABASE=MyTestDB -e MARIADB_ROOT_PASSWORD=rootPwd1 -e MARIADB_USER=testUser -e MARIADB_PASSWORD=userPwd1 -v mariadb_myTestData:/var/lib/mysql -h myHost1 -d mariadb
    echo 'Start the new container'
    docker start mariadb_container1
elif [ "$1" == "down" ];  then
    echo 'Stop and remove the container'
    docker stop mariadb_container1
    docker rm mariadb_container1
elif [ "$1" == "sqlroot" ];  then
    # start a SQL interactive console with root user
    docker exec -it mariadb_container1 mariadb -uroot -p
elif [ "$1" == "sqluser" ];  then
    # start a SQL interactive console with a test user
    docker exec -it mariadb_container1 mariadb --user=testUser -p
elif [ "$1" == "bash" ];  then
    # start a bash session to the container
    docker exec -it mariadb_container1 bash
fi
