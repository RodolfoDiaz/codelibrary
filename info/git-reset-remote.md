# Resetting remote to a certain commit

Assuming that your branch is called master both here and remotely, and that your remote is called origin you could do:

    git reset --hard <commit-hash>
    git push -f origin master

You can use **git log** to review the history of changes.