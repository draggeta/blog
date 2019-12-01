#!/bin/bash

# abort if any command fails
set -e

# add required packages for git to run
apk add --update git openssh-client bash git-subtree ca-certificates

# enable ssh-agent, as it's not running in the container and add the key
printf "Enable and set up SSH agent\n"
eval `ssh-agent`
printf "%s" "${GHA_DEPLOY_KEY}" | ssh-add -

printf "Set up git SSH configuration\n"
git config --global core.sshCommand "ssh -o IdentitiesOnly=no -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -F /dev/null"
git config --global status.submodulesummary 1
git config --global diff.submodule log

# setup the git configuration for the parent repository
printf "Set up git user configuration\n"
git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"

# add the website repo as a submodule, in the public directory
printf "Add the pages repository as a submodule\n"
git submodule add -b master git@github.com:draggeta/draggeta.github.io.git public

# Remove all files from the pages repository so no old files remain
printf "Clean the pages repository\n"
cd public

# remove all files and folders except .git folder
find . -mindepth 1 -maxdepth 1 ! -regex '^\./\.git' -exec rm -rf {} \;

printf "Done!"
