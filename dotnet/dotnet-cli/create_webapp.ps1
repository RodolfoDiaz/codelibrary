# .NET CLI code sample
# https://docs.microsoft.com/en-us/dotnet/core/tools/

New-Variable -Name "AppName" -Visibility Public -Value "myWebApp"
echo "---> Remove app folder (if found)"
if ( Test-Path -Path $AppName -PathType Container ) { Remove-Item -path $AppName -Recurse –force }
echo "---> Create a new Web Application"
# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-new
dotnet new webApp -o $AppName --no-https
echo "---> Create .gitignore"
dotnet new gitignore --output $AppName
echo "---> Build the Web Application"
# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-build
dotnet build $AppName

# echo "---> Run the Web Application (hit Ctrl-C to exit)"
# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-run
dotnet run --project .\$AppName\
# Browse to: http://localhost:5000