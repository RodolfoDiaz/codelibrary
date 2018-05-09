if [ "$(uname)" == "Darwin" ]; then
    echo "Install Java in macOS using Homebrew"
    brew update
    # brew tap caskroom/versions
    # brew cask install java8
    brew cask install java
    # Verify that Java and the Java compiler have been properly installed
    java -version
    javac -version
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Java in Ubuntu Linux"
    # First, update the package index.
    sudo apt-get update && sudo apt-get upgrade
    # sudo apt-get install default-jre
    sudo apt-get install default-jdk
    # Set Java Home Environment
    # To set the variable for your system:
    echo "JAVA_HOME=$(which java)" | sudo tee -a /etc/environment
    # Reload your system’s environment variables:
    source /etc/environment
    # Verify the variable was set correctly:
    echo $JAVA_HOME
fi