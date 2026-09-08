MyAppName="DemoApp"
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

# Create a new Class Library project
dotnet new classlib -o $DemoClassLibName

# Add projects to the solution
dotnet sln add $WebAppName/$WebAppName.csproj
dotnet sln add $DemoClassLibName/$DemoClassLibName.csproj

# Add a reference from Class Library project to Web Application project
dotnet add $WebAppName/$WebAppName.csproj reference $DemoClassLibName/$DemoClassLibName.csproj

# Add a .gitignore file to the solution
dotnet new gitignore

# Update Nuget packages
dotnet package update --project $WebAppName
dotnet package update --project $DemoClassLibName

# Run the Web Application project
dotnet run --project $WebAppName --launch-profile https
