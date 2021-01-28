# .NET CLI code sample
# https://docs.microsoft.com/en-us/dotnet/core/tools/

New-Variable -Name "AppName" -Visibility Public -Value "myWebApp"
if ( Test-Path -Path $AppName -PathType Container ) { Remove-Item -path $AppName -Recurse –force }
Write-Host "---> Create a new Web Application" -ForegroundColor Green
# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-new
dotnet new webApp -o $AppName --no-https
Write-Host "---> Create .gitignore"  -ForegroundColor Green
dotnet new gitignore --output $AppName
Write-Host "---> Build the Web Application" -ForegroundColor Green
# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-build
dotnet build $AppName

Write-Host "---> Building Web Application (hit Ctrl-C to exit)" -ForegroundColor Green
# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-run
dotnet run --project .\$AppName\
# Browse to: http://localhost:5000