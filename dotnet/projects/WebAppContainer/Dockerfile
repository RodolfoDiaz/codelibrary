# --- TO USE THIS FILE ---
# First, run the following commands (in PowerShell):
# 1- "Create-WebApp.ps1": this file creates a new ASP.NET Core web application and builds it.
# 2- "Run-WebAppContainer.ps1": this file uses the Dockerfile below to build the image and run the container.
# 3- You can also make changes to the web application source code (./myWebApp), then rebuild the image
#    by running "Run-WebAppContainer.ps1" again to see the changes in the web application.
#
# A Dockerfile is a simple text file that contains a step-by-step recipe of instructions used to build a Docker image.
# About Microsoft's .NET Docker images: https://hub.docker.com/r/microsoft/dotnet

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build-env
WORKDIR /myWebApp

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /myWebApp
COPY --from=build-env /myWebApp/out .
ENTRYPOINT ["dotnet", "myWebApp.dll"]