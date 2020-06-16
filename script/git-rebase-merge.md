# Git rebase and merge example 

Additional reference:
* https://git-scm.com/docs/git-rebase
* https://git-scm.com/docs/git-merge
* http://nvie.com/posts/a-successful-git-branching-model/
* https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow


Replace the name *RELEASE_BRANCH* with 'master' or the release branch name.
The *FEATURE_BRANCH* is the development branch you are currently working on.

    git checkout *RELEASE_BRANCH*
    git pull
    git checkout *FEATURE_BRANCH*
    git pull origin *FEATURE_BRANCH*
    git rebase *RELEASE_BRANCH* 
    # If you see code merge conflicts then you will need to: 
    # a- Resolve the conflict using a text editor or IDE.
    # b- Execute "git add ." to add those files changed.
    # c- Execute "git rebase --continue" to complete the rebase,
    #    if you want to dismiss, then "git rebase --abort"

    git checkout *RELEASE_BRANCH*
    git merge *FEATURE_BRANCH* --no-ff

Version number change, perhaps using a task with gulp-bump

    gulp prerelease-version
    git add .
    git commit -m "Version number change"
    git push origin *RELEASE_BRANCH*
