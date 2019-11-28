#!/bin/sh
apk add --update git openssh-client bash git-subtree         \
    findutils py-pygments asciidoctor libc6-compat libstdc++ \
    ca-certificates

if ! git diff --no-ext-diff --quiet --exit-code; then
    SSH_PATH="~/.ssh"
    KEY_FILENAME="id_rsa"
    mkdir -p "${SSH_PATH}"
    chmod 750 "${SSH_PATH}"

    # echo ${GHA_DEPLOY_KEY} > "${SSH_PATH}/${KEY_FILENAME}"
    cp "${GITHUB_WORKSPACE}/.ssh/${KEY_FILENAME}" > "${SSH_PATH}/${KEY_FILENAME}"
    chmod 600 "${SSH_PATH}/${KEY_FILENAME}"

    echo -e "Host github.com\n\tIdentityFile ${SSH_PATH}/${KEY_FILENAME}\n\tStrictHostKeyChecking no\n\tAddKeysToAgent yes\n" >> "${SSH_PATH}/config"
    chmod 640 "${SSH_PATH}/config"

    ssh-keyscan github.com >> "${SSH_PATH}/known_hosts"
    chmod 640 "${SSH_PATH}/known_hosts"

    chown root:root -R "${SSH_PATH}"

    ls -al "${SSH_PATH}/"

    eval `ssh-agent`
    ssh-add ${SSH_PATH}/${KEY_FILENAME}

    cd public

    git config --local user.name "${GITHUB_ACTOR}"
    git config --local user.email "${GITHUB_ACTOR}@users.noreply.github.com"
    git config --global core.sshCommand "ssh -o IdentitiesOnly=yes -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${SSH_PATH}/id_rsa -F /dev/null"
    git config --global status.submodulesummary 1
    git config --global diff.submodule log

    git fetch
    git pull origin master

    git add .

    echo -n 'Files to Commit:' && ls -l | wc -l
    timestamp=$(date +%s%3N)
    git commit -am "Automated deployment to GitHub Pages on $timestamp"

    git remote set-url origin "$(git config --get remote.origin.url | sed 's#http.*com/#git@github.com:#g')"

    git push origin master


    # #       git push
    # #       ssh-agent -k


    echo "Done!"
fi
