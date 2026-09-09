MyAppName="MyDemoApp"
WebAppName="DemoWebApp"
DemoClassLibName="DemoClassLib"

# 1. Check if the directory exists
if [ -d "$MyAppName" ]; then
    echo "The directory '$MyAppName' already exists."

    # 2. Ask the user whether to remove it
    read -p "Do you want to remove it and continue? (Y/N) [Default: n]: " answer
    if [ "${answer,,}" == "y" ]; then
        echo "Removing directory..."
        rm -rf $MyAppName
    else
        # 3. Exit the script if the user chooses not to remove the $MyAppName directory
        echo "Operation cancelled."
        exit 1
    fi
fi

# Create solution directory and solution file
mkdir $MyAppName && cd $MyAppName
dotnet new sln

# Create a new ASP.NET Core Web Application project
dotnet new webapp --auth Individual -o $WebAppName
dotnet add package Microsoft.Web.LibraryManager.Build --project $WebAppName

# Create a new Class Library project
dotnet new classlib -o $DemoClassLibName

# Add projects to the solution
dotnet sln add $WebAppName/$WebAppName.csproj
dotnet sln add $DemoClassLibName/$DemoClassLibName.csproj

# Add a reference from Class Library project to Web Application project
dotnet add $WebAppName/$WebAppName.csproj reference $DemoClassLibName/$DemoClassLibName.csproj

# Add a .gitignore file to the solution
dotnet new gitignore

# Exclude wwwroot/lib from source control using .gitignore because it contains
# third-party client-side libraries that can be restored.
# Why? Bloat reduction, Separation of concerns and Restorability.
echo "**/wwwroot/lib/" >> .gitignore

echo "Update Nuget packages for all projects"
dotnet package update --project $WebAppName
dotnet package update --project $DemoClassLibName

# 1. Install the LibMan CLI globally (if you haven't already)
dotnet tool install --global Microsoft.Web.LibraryManager.Cli

echo "Removing the wwwroot/lib directory created by default by the 'dotnet new webapp' tool."
echo "We will replace client side libraries with those installed via LibMan"
rm -rf $WebAppName/wwwroot/lib

# 2. Initialize LibMan in your project root (creates libman.json)
cd $WebAppName
echo "Initializing LibMan in the project root..."
libman init --default-provider cdnjs

# 3. Install required libraries using LibMan
libman install bootstrap@5.3.8 --provider cdnjs --destination wwwroot/lib/bootstrap/dist
libman install jquery@3.7.1 --provider cdnjs --destination wwwroot/lib/jquery/dist
libman install jquery-validate@1.22.1 --provider cdnjs --destination wwwroot/lib/jquery-validate/dist
libman install jquery-validation-unobtrusive@4.0.0 --provider cdnjs --destination wwwroot/lib/jquery-validation-unobtrusive/dist

# libman restore

# Run the Web Application project
dotnet run --launch-profile https
