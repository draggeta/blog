#!/bin/sh

# abort if any command fails
set -e

# add required packages for git to run
apk add --update git openssh-client bash git-subtree ca-certificates

# if differences are found, run
if ! git diff --no-ext-diff --quiet --exit-code; then
    # enable ssh-agent, as it's not running in the container and add the key
    eval `ssh-agent`
    printf "%s" "${GHA_DEPLOY_KEY}" | ssh-add - #

    cd public

    git config --local user.name "${GITHUB_ACTOR}"
    git config --local user.email "${GITHUB_ACTOR}@users.noreply.github.com"
    git config --global core.sshCommand "ssh -o IdentitiesOnly=no -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -F /dev/null" #"
    git config --global status.submodulesummary 1
    git config --global diff.submodule log

    git fetch
    git pull origin master

    git add .

    # replace the https remote to ssh remote
    git remote set-url origin "$(git config --get remote.origin.url | sed 's#http.*com/#git@github.com:#g')"

    echo -n 'Files to Commit:' && ls -l | wc -l
    timestamp=$(date +%s%3N)
    git commit -am "Automated deployment to GitHub Pages on $timestamp"

    # store the headless commit in a separate branch
    git checkout -b temp_data

    git checkout master

    # and merge the commit into master
    git merge temp_data

    git push

    echo "Done!"
fi
