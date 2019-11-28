#!/bin/sh

# abort if any command fails
set -e

# add required packages for git to run
apk add --update git openssh-client bash git-subtree         \
    findutils py-pygments asciidoctor libc6-compat libstdc++ \
    ca-certificates

# if differences are found, run
if ! git diff --no-ext-diff --quiet --exit-code; then
    SSH_PATH="${GITHUB_WORKSPACE}/.ssh"
    KEY_FILENAME="id_rsa"

    # create the ssh folder and set the permissions needed
    mkdir -p "${SSH_PATH}"
    chmod 750 "${SSH_PATH}"

    printf "%s" "${GHA_DEPLOY_KEY}" > "${SSH_PATH}/${KEY_FILENAME}2"
    diff "${SSH_PATH}/${KEY_FILENAME}" "${SSH_PATH}/${KEY_FILENAME}2"
    # cp "${GITHUB_WORKSPACE}/.ssh/${KEY_FILENAME}" "${SSH_PATH}/${KEY_FILENAME}"
    chmod 600 "${SSH_PATH}/${KEY_FILENAME}"

    # add github.com to the known hosts file
    ssh-keyscan github.com >> "${SSH_PATH}/known_hosts"
    chmod 640 "${SSH_PATH}/known_hosts"

    chown root:root -R "${SSH_PATH}"

    # enable ssh-agent, as it's not running in the container and add the key
    eval `ssh-agent`
    ssh-add ${SSH_PATH}/${KEY_FILENAME}

    cd public

    git config --local user.name "${GITHUB_ACTOR}"
    git config --local user.email "${GITHUB_ACTOR}@users.noreply.github.com"
    git config --global core.sshCommand "ssh -i ${SSH_PATH}/${KEY_FILENAME} -o IdentitiesOnly=yes -o UserKnownHostsFile=${SSH_PATH}/known_hosts -F /dev/null" #-o StrictHostKeyChecking=no"
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
