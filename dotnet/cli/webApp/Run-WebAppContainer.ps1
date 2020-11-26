New-Variable -Name "AppName" -Visibility Public -Value "myWebApp"
New-Variable -Name "ContainerName" -Visibility Public -Value "myapp"
New-Variable -Name "ImageName" -Visibility Public -Value "aspnetapp"

Write-Output "---> Copy Docker files"
Copy-Item "Dockerfile" -Destination $AppName
Copy-Item ".dockerignore" -Destination $AppName
Set-Location -Path $AppName

Write-Output "---> Build application image"
docker build -t $ImageName .

Write-Output "---> docker rm: Remove the container $ContainerName"
docker rm $ContainerName

Write-Output "---> docker run: Run a command in a new container"
docker run -d -p 8080:80 --name $ContainerName $ImageName

Write-Host "---> Browse to: http://localhost:8080.  Hit Enter to stop the container and perform cleanup" -ForegroundColor Green
Read-Host
docker stop $ContainerName
Write-Output "---> docker ps: List all containers"
docker ps -a
# Write-Output "---> docker start: Start one or more stopped containers"
# docker start $ContainerName
Write-Output "---> docker rm: Remove the container $ContainerName"
docker rm $ContainerName
Write-Output "---> docker rm: Remove image $ImageName"
docker image rm $ImageName
Set-Location ..