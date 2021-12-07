if [ "$1" == "" ]; then
    echo "GitHub Personal Access Token argument was missing."
    exit
fi
paramGitUser="RodolfoDiaz"
paramRepoName="codelibrary.git"
paramToken="$1"
git remote set-url origin https://$paramToken@github.com/$paramGitUser/$paramRepoName
echo "---> Personal Access Token was updated!"
git remote -v
