#!/bin/sh

# abort if any command fails
set -e

# add required packages for git to run
apk add --update git openssh-client bash git-subtree ca-certificates

printf "Check if there is any differences in git\n"

# if differences are found, run
if ! git diff --no-ext-diff --quiet --exit-code; then
    # enable ssh-agent, as it's not running in the container and add the key
    printf "Enable and set up SSH agent\n"
    eval `ssh-agent`
    printf "%s" "${GHA_DEPLOY_KEY}" | ssh-add -

    printf "Stage all files in the pages repository\n"
    cd public
    git add .

    printf "Commit all files in the pages repository\n"
    echo -n 'Files to Commit:' && ls -l | wc -l
    git commit -am "Automated deployment to GitHub Pages on $(date)"

    printf "Push all changes to the pages repository"
    git push

fi

printf "Done!"
