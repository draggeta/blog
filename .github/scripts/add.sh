#!/bin/bash

# abort if any command fails
set -e

# add required packages for git to run
apk add --update git openssh-client bash git-subtree ca-certificates

# enable ssh-agent, as it's not running in the container and add the key
eval `ssh-agent`
printf "%s" "${GHA_DEPLOY_KEY}" | ssh-add -

# setup the git configuration for the parent repository
git config --local user.name "${GITHUB_ACTOR}"
git config --local user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git config --global core.sshCommand "ssh -o IdentitiesOnly=no -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -F /dev/null"
git config --global status.submodulesummary 1
git config --global diff.submodule log

# add the website repo as a submodule, in the public directory
git submodule add -b master git@github.com:draggeta/draggeta.github.io.git public

cd public

# setup the git configuration for the submodule repository
git config --local user.name "${GITHUB_ACTOR}"
git config --local user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git config --global core.sshCommand "ssh -o IdentitiesOnly=no -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -F /dev/null"
git config --global status.submodulesummary 1
git config --global diff.submodule log

ls -al

# remove all files and folders except .git folder
find . -mindepth 1 -maxdepth 1 ! -regex '^\./\.git' -exec echo rm -rf {} \;
# find . -mindepth 1 -maxdepth 1 ! -regex '^\./\.git\(/.*\)?' | xargs -n1 echo rm -rf

ls -al

echo "Done!"
