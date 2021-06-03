if [ "$(uname)" == "Darwin" ]; then
  alias ll='ls -lGa'
  alias brewski='brew update && brew upgrade && brew cleanup'
  #   brew install coreutils
  #   alias ll='ls -la --color -h --group-directories-first'
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  echo "alias lx='ls -la --color -h --group-directories-first'" >> ~/.bash_aliases
  echo "alias linux_update='sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade'" >> ~/.bash_aliases
  echo "alias linux_version='lsb_release -a && uname -srm'" >> ~/.bash_aliases
fi