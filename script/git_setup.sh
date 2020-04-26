# Install Git - https://git-scm.com
if [ "$(uname)" == "Darwin" ]; then
    echo "Install Git in macOS"
    # You need to change the '~/.bash_profile' file, add the following line:
    #   export PATH="/usr/local/bin:${PATH}"
    # This little one liner allows us to update Git and use the Homebrew installation instead of our Native OS’. 
    brew install git
    brew upgrade git
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Git in Linux"
    sudo apt install git -y
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    echo "Download Git for 32 bits Windows NT platform - https://git-scm.com/download/win"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    echo "Download Git for 64 bits Windows NT platform - https://git-scm.com/download/win"
    # Credential helper alleviates the need for you to continually enter your credentials when interacting with Github
    # https://github.com/Microsoft/Git-Credential-Manager-for-Windows
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
  git add .
  git commit -m "Initial commit"
  git push -u origin master
fi
