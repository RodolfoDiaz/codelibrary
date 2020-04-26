# https://openjdk.java.net/projects/jdk/
if [ "$(uname)" == "Darwin" ]; then
    if [ "$1" == "i" ]; then
        echo "Install Java in macOS using Homebrew"
        # JDK LATEST VERSION:
        # brew install openjdk
        # sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
        # JDK VERSION 11
        brew install openjdk@11
        sudo ln -sfn /usr/local/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
        # Verify that Java and the Java compiler have been properly installed
        java -version
        javac -version
    fi

    if [ "$1" == "u" ]; then
        echo "Uninstall Java in macOS using Homebrew"
        # JDK LATEST VERSION:
        # sudo unlink /Library/Java/JavaVirtualMachines/openjdk.jdk
        # brew uninstall openjdk
        # JDK VERSION 11
        sudo unlink /Library/Java/JavaVirtualMachines/openjdk-11.jdk
        brew uninstall openjdk@11
    fi

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Java in Ubuntu Linux"
    # First, update the package index.
    sudo apt update && sudo apt upgrade
    sudo apt install default-jre -y
    java -version
    sudo apt install default-jdk -y
    javac -version
    # Set Java Home Environment
    # To set the variable for your system:
    echo "JAVA_HOME=$(which java)" | sudo tee -a /etc/environment
    # Reload your system’s environment variables:
    source /etc/environment
    # Verify the variable was set correctly:
    echo $JAVA_HOME
fi