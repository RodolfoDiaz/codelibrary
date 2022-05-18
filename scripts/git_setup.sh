# Install Git - https://git-scm.com
# Git Credential Manager - https://github.com/microsoft/Git-Credential-Manager-Core
if [ "$(uname)" == "Darwin" ]; then
    echo "Install Git in macOS"
    # You need to change the '~/.bash_profile' file, add the following line:
    #   export PATH="/usr/local/bin:${PATH}"
    # This little one liner allows us to update Git and use the Homebrew installation instead of our Native OS’.
    brew install git
    brew upgrade git

    # On Mac, you can use osxkeychain helper. Use the following command on your terminal:
    git config --global credential.helper osxkeychain

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Git in Linux"
    sudo add-apt-repository ppa:git-core/ppa -y
    sudo apt-get update
    sudo apt install git -y
    
    # Install the latest gcmcore-linux .deb package (https://github.com/microsoft/Git-Credential-Manager-Core/releases/latest)
    sudo apt install pass
    wget "https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.0.696/gcmcore-linux_amd64.2.0.696.deb" -O /tmp/gcmcore.deb
    sudo dpkg -i /tmp/gcmcore.deb
    git-credential-manager-core configure
    git config --global credential.credentialStore gpg
    # The following command will ask for the user name and email address.
    gpg --gen-key
    # Get the gpg-id value (created in previous step)
    gpg --list-keys
    # Initialize the Password Store
    #pass init <gpg-id>

    # ---> You can also try configuring GCM with Git on Windows Subsystem for Linux (WSL)
    # https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-git
    
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    echo "Download Git for 32 bits Windows NT platform - https://git-scm.com/download/win"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    echo "Download Git for 64 bits Windows NT platform - https://git-scm.com/download/win"
    # ---- Git install package for Windows already includes a copy of Git Credentials Manager ----

    # Using this command will store your passwords unencrypted on disk, protected only by filesystem permissions. (NOT RECOMMENDED)
    # git config --global credential.helper store

    # If you use wincred for credential.helper, git is using the standard Windows Credential Manager to store your credentials.
    git config --global credential.helper wincred

    # This command caches credentials in memory (https://git-scm.com/docs/git-credential-cache).  A pop-up message will prompt for credentials.
    # git config --global credential.helper 'cache --timeout=3600'

    # Use separate credentials for different repositories on github.com
    git config --global credential.github.com.useHttpPath true
    git config --global credential.https://dev.azure.com.useHttpPath true

fi
# Configuration settings file is located at ~/.gitconfig
git config --global user.email "rodolfodc@hotmail.com"
git config --global user.name "RodolfoDiaz"
git config --global core.editor "nano"

# Force git to use https:// instead of git:// protocol, because git protocol is blocked by the some firewalls.
# git config --global --add url.https://github.com.insteadof git://github.com
# git config --global url."https://github.com/".insteadOf git@github.com:
# git config --global url."https://".insteadOf git://

# (Windows only) Ignore the 260 character path limit and allow longer file paths when doing a git clone.
# git config --global --add core.longpaths true

# For Windows users enter:
# git config --global core.autocrlf true
# For Mac or Linux users enter:
# git config --global core.autocrlf input

echo "These are system-wide configurations. They apply to all users on this computer."
git config --list --system
echo "These are the user-level configurations. They only apply to your user account."
git config --list --global
# echo "These are the repository-level configurations. They only apply to the specific repository where they are set."
# git config --list --local

# Start using git, create a repository and add some code:
if [ "$1" == "new" ]; then
    # To create the repository using GitHub website, log in to your user account at https://github.com/
    # under 'Repositories' click New button.
    # Fill in the repository name and click the “Create repository” button.
    # To create the repo from command line, you will need to have a GitHub Personal Access Token and execute this:
    # curl -u "$username:$token" https://api.github.com/user/repos -d '{"name":"'$repo_name'"}'
    mkdir my_new_repo
    cd my_new_repo
    git init
    git remote add origin https://github.com/[your-git-org]/[new-git-repo].git
    git pull origin master
    echo "My new repository test file" >> test.txt;
    touch setup.sh
    git add .
    git commit -m "Initial commit"
    git push -u origin master
    # List the contents of a tree object - https://git-scm.com/docs/git-ls-tree
    git ls-tree HEAD . -l
    # Set the execute permissions on the updated files - https://git-scm.com/docs/git-update-index
    git update-index --chmod=+x setup.sh
    git add .
    git commit -m "Changed file mode"
fi
