New-Variable -Name "AppName" -Visibility Public -Value "myWebApp"
New-Variable -Name "ContainerName" -Visibility Public -Value "mywebapp-container"
New-Variable -Name "ImageName" -Visibility Public -Value "mywebapp-image"

Write-Output "---> Copy Docker files"
Copy-Item "Dockerfile" -Destination $AppName
Copy-Item ".dockerignore" -Destination $AppName
Set-Location -Path $AppName

Write-Output "---> Build application image"
docker build -t $ImageName .

Write-Output "---> docker rm: Remove the container $ContainerName"
docker rm $ContainerName

Write-Output "---> docker run: Run a command in a new container"
docker run -d -p 8081:8080 --name $ContainerName $ImageName

Write-Host "---> Browse to: http://localhost:8081.  Hit Enter to stop the container and perform cleanup" -ForegroundColor Green
Read-Host
Write-Host "Stopping the container..." -ForegroundColor Red
docker stop $ContainerName
Write-Output "---> docker ps: List all containers"
docker ps -a
# Write-Output "---> docker start: Start one or more stopped containers"
# docker start $ContainerName

# Display the question in green and keep the cursor on the same line
Write-Host "Do you want to remove the containers and images created for $AppName? (Y/N)" -ForegroundColor Green -NoNewline

# Read the user's input
$response = Read-Host

# Check if the response matches 'y' (case-insensitive)
if ($response -eq 'y') {
    Write-Output "---> docker rm: Remove the container $ContainerName" -ForegroundColor Red
    docker rm $ContainerName
    Write-Output "---> docker rm: Remove image $ImageName" -ForegroundColor Red
    docker image rm $ImageName
    Write-Output "---> docker builder prune: Remove build cache" -ForegroundColor Red
    docker builder prune --force
} else {
    Write-Host "Action cancelled by user." -ForegroundColor Yellow
}

Set-Location ..