# Install Git
# https://git-scm.com/download/linux
if [ "$(uname)" == "Darwin" ]; then
    echo "Install Git in macOS"
    # First you need to Cchange the '~/.bash_profile' file, as follows:
    #       export PATH=/usr/local/bin:$PATH
    # http://blog.grayghostvisuals.com/git/how-to-keep-git-updated/
    brew install git
    brew upgrade git
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Git in Linux"
    sudo apt-get install git -y
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    echo "Do something under 32 bits Windows NT platform"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    echo "Do something under 64 bits Windows NT platform"
fi
git config --global user.email "rodolfodc@hotmail.com"
git config --global user.name "RodolfoDiaz"
git config --global core.editor "nano"
git config --list