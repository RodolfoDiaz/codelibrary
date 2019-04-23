# https://hub.docker.com/_/mysql
if [ "$1" == "up" ]; then
    docker pull mysql
    docker image ls -a
    docker container ls -a
    # Create a new MySQL container
    docker run -p 3306:3306 --name mysql_container1 -e MYSQL_DATABASE=MyTestDB -e MYSQL_ROOT_PASSWORD=rootPwd1 -e MYSQL_USER=testUser -e MYSQL_PASSWORD=userPwd1 -h mySql1 -d mysql
    echo 'Start the new container'
    docker start mysql_container1
elif [ "$1" == "down" ];  then
    echo 'Stop and remove the container'
    docker stop mysql_container1
    docker rm mysql_container1
elif [ "$1" == "sqlroot" ];  then
    # start a SQL interactive console with root user
    docker exec -it mysql_container1 mysql -uroot -p
elif [ "$1" == "sqluser" ];  then
    # start a SQL interactive console with a test user
    docker exec -it mysql_container1 mysql --user=testUser -p
elif [ "$1" == "bash" ];  then
    # start a bash session to the container
    docker exec -it mysql_container1 bash
fi
