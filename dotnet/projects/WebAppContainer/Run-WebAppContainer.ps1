# This file copies the web application created under $AppName folder in a Docker container.
# See the 'Dockerfile' in this folder for more details.

New-Variable -Name "AppName" -Visibility Public -Value "myWebApp"
New-Variable -Name "ContainerName" -Visibility Public -Value "mywebapp-container"
New-Variable -Name "ImageName" -Visibility Public -Value "mywebapp-image"

Write-Host "---> Copy Docker files inside the $AppName folder" -ForegroundColor Green
Copy-Item "Dockerfile" -Destination $AppName
Copy-Item ".dockerignore" -Destination $AppName
Set-Location -Path $AppName

Write-Host "---> Build application image" -ForegroundColor Green
docker build -t $ImageName .

Write-Host "---> Stop and remove the container $ContainerName (if exists)" -ForegroundColor Yellow
docker stop $ContainerName
docker rm $ContainerName

Write-Host "---> docker run: Run a command in a new container" -ForegroundColor Green
docker run -d -p 8081:8080 --name $ContainerName $ImageName

Write-Host "---> Browse to: http://localhost:8081.  Hit Enter to stop the container and perform cleanup" -ForegroundColor Green
Read-Host
Write-Host "Stopping the container..." -ForegroundColor Yellow
docker stop $ContainerName
Write-Host "---> docker ps: List all containers" -ForegroundColor Green
docker ps -a

# Display the question in green and keep the cursor on the same line
Write-Host "Do you want to remove the containers and images created for $AppName? (Y/N)" -ForegroundColor Green -NoNewline

# Read the user's input
$response = Read-Host

# Check if the response matches 'y' (case-insensitive)
if ($response -eq 'y') {
    Write-Host "---> Remove the container: $ContainerName" -ForegroundColor Red
    docker rm $ContainerName
    Write-Host "---> Remove the image: $ImageName" -ForegroundColor Red
    docker image rm $ImageName
    Write-Host "---> Cleanup docker builder cache" -ForegroundColor Red
    docker builder prune --force
} else {
    Write-Host "Action cancelled by user." -ForegroundColor Yellow
}

Set-Location ..

# Write-Host "---> If you want to restart the container without rebuilding the image, run the following command:" -ForegroundColor Green
# docker start $ContainerName
