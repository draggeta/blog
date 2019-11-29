#!/bin/sh

# abort if any command fails
set -e

# add required packages for git to run
apk add --update git openssh-client bash git-subtree ca-certificates

# if differences are found, run
if ! git diff --no-ext-diff --quiet --exit-code; then
    # enable ssh-agent, as it's not running in the container and add the key
    eval `ssh-agent`
    printf "%s" "${GHA_DEPLOY_KEY}" | ssh-add -

    cd public

    git fetch
    git pull origin master

    git add .

    echo -n 'Files to Commit:' && ls -l | wc -l
    git commit -am "Automated deployment to GitHub Pages on $(date)"

    git push

    echo "Done!"
fi
