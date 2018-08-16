# Install Git - https://git-scm.com
if [ "$(uname)" == "Darwin" ]; then
    echo "Install Git in macOS"
    # You need to change the '~/.bash_profile' file, add the following line:
    #   export PATH=/usr/local/bin:$PATH
    # This little one liner allows us to update Git and use the Homebrew installation instead of our Native OS’. 
    brew install git
    brew upgrade git
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Git in Linux"
    sudo apt-get install git -y
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    echo "Download Git for 32 bits Windows NT platform - https://git-scm.com/download/win"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    echo "Download Git for 64 bits Windows NT platform - https://git-scm.com/download/win"
    # Credential helper alleviates the need for you to continually enter your credentials when interacting with Github
    # https://github.com/Microsoft/Git-Credential-Manager-for-Windows
fi
# Configuration settings file is located at ~/.gitconfig
git config --global user.email "rodolfodc@hotmail.com"
git config --global user.name "Rodolfo Diaz"
git config --global core.editor "nano"
# Use ‘https’ instead of the git protocol since the git protocol is blocked by the some firewalls.
git config --global --add url.https://github.com.insteadof git://github.com
# (Windows only) Ignore the 260 character path limit and allow longer file paths when doing a git clone.
#git config --global --add core.longpaths true
git config --list --global
# Start using git, for example:
#	 git init
#    git add .
#    git commit -m "Initial commit"
#    git remote add origin https://github.com/[your-app-org]/[your-app-repo].git
#    git push -u origin master