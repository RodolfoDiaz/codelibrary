# Official images for .NET and ASP.NET Core
# https://hub.docker.com/_/microsoft-dotnet
#
# Example taken from https://docs.docker.com/engine/examples/dotnetcore/

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR $PWD/myWebApp

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR $PWD/myWebApp
COPY --from=build-env $PWD/myWebApp/out .
ENTRYPOINT ["dotnet", "myWebApp.dll"]