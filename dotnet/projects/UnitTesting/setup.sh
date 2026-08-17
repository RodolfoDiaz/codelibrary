# Create solution directory and solution file
mkdir MathApp && cd MathApp
dotnet new sln

# Create Console Application
dotnet new console -o MathApp

# Create xUnit Test Project
dotnet new xunit -o MathApp.Tests

# Add projects to the solution
dotnet sln add MathApp/MathApp.csproj
dotnet sln add MathApp.Tests/MathApp.Tests.csproj

# Add reference from Tests project to Console project
dotnet add MathApp.Tests/MathApp.Tests.csproj reference MathApp/MathApp.csproj

# Add a .gitignore file to the solution
dotnet new gitignore
