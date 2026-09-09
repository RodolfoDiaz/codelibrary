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

echo "*/wwwroot/lib/" >> .gitignore

# Update Nuget packages
dotnet package update --project $WebAppName
dotnet package update --project $DemoClassLibName

echo "Removing the existing wwwroot/lib directory if it exists..."
rm -rf $WebAppName/wwwroot/lib

echo "We will replace it with the libraries installed via LibMan"
# 1. Install the LibMan CLI globally (if you haven't already)
dotnet tool install --global Microsoft.Web.LibraryManager.Cli

# 2. Initialize LibMan in your project root (creates libman.json)
libman init --default-provider cdnjs

mv libman.json $WebAppName

# 3. Install required libraries using LibMan
libman install bootstrap@5.3.8 --provider cdnjs --destination wwwroot/lib/bootstrap/dist
libman install jquery@3.7.1 --provider cdnjs --destination wwwroot/lib/jquery/dist
libman install jquery-validate@1.22.1 --provider cdnjs --destination wwwroot/lib/jquery-validate/dist
libman install jquery-validation-unobtrusive@4.0.0 --provider cdnjs --destination wwwroot/lib/jquery-validation-unobtrusive/dist

cd $WebAppName

# Run the Web Application project
dotnet run --project $WebAppName --launch-profile https
