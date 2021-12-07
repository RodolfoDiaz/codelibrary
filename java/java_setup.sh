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

    # Apple recommends to set the $JAVA_HOME variable to /usr/libexec/java_home, 
    # just export $JAVA_HOME in file ~/.zshrc or ~/.bash_profile or ~/.profile.

    # export JAVA_HOME=$(/usr/libexec/java_home)

    # Check versions installed:
    # /usr/libexec/java_home -V

    echo "Your JAVA_HOME environment variable points to: $JAVA_HOME"

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Java in Ubuntu Linux"
    #--- First, update the package index.
    sudo add-apt-repository ppa:openjdk-r/ppa
    sudo apt update
    #--- To install an specific version:
    # sudo apt install openjdk-8-jdk
    # sudo apt install openjdk-11-jdk
    #--- The following commands install the default JRE and JDK in OpenJDK:
    sudo apt install default-jre -y
    java -version
    sudo apt install default-jdk -y
    javac -version
    sudo apt-cache search openjdk
    #--- Set Java Home Environment
    #--- To set the variable for your system:
    echo "JAVA_HOME=$(which java)" | sudo tee -a /etc/environment
    #--- Reload your system’s environment variables:
    source /etc/environment
    #--- Verify the variable was set correctly:
    echo $JAVA_HOME
fi