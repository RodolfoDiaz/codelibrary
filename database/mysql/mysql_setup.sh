# https://hub.docker.com/_/mysql
docker pull mysql
docker image ls -a
docker container ls -a
docker ps
# Starting a MySQL Server Instance
docker run -p 3306:3306 --name mysql_container1 -e MYSQL_ROOT_PASSWORD=rootPwd1 -d mysql
# start a bash session to the container
docker exec -it mysql_container1 bash
# start an SQL interactive console with root user
docker exec -it mysql_container1 mysql -uroot -p
# start an SQL interactive console with a test user
docker exec -it mysql_container1 mysql --user=testUser -p
docker start mysql_container1
docker stop mysql_container1