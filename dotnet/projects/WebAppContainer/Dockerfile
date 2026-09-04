# --- TO EXECUTE THIS FILE ---
# https://hub.docker.com/r/microsoft/dotnet
# First, run the following commands (in PowerShell):
# 1- "Create-WebApp.ps1" (this file creates a new ASP.NET Core web application and builds it)
# 2- "Run-WebAppContainer.ps1" (this file uses the Dockerfile below to build the image and run the container)
# 3- You can also make changes to the web application source code (./myWebApp),
#    then rebuild the image by running "Run-WebAppContainer.ps1" again.

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