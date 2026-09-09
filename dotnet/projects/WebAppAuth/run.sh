MyAppName="MyDemoApp"
WebAppName="DemoWebApp"

cd $MyAppName

# Run the Web Application project
dotnet run --project $WebAppName  --launch-profile https
