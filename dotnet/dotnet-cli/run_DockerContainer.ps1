New-Variable -Name "AppName" -Visibility Public -Value "myWebApp"
New-Variable -Name "ContainerName" -Visibility Public -Value "myapp"
New-Variable -Name "ImageName" -Visibility Public -Value "aspnetapp"

echo "---> Copy Docker files"
Copy-Item "Dockerfile" -Destination $AppName
Copy-Item ".dockerignore" -Destination $AppName
Set-Location -Path $AppName

docker build -t $ImageName .

echo "---> docker rm: Remove the container $ContainerName"
docker rm $ContainerName
echo "---> docker run: Run a command in a new container"
docker run -d -p 8080:80 --name $ContainerName $ImageName
# Browse to: http://localhost:8080
echo "---> Hit Enter to stop the container"
Read-Host
docker stop $ContainerName
echo "---> docker ps: List all containers"
docker ps -a
# echo "---> docker start: Start one or more stopped containers"
# docker start $ContainerName
echo "---> docker rm: Remove the container $ContainerName"
docker rm $ContainerName
echo "---> docker rm: Remove image $ImageName"
docker image rm $ImageName
cd ..