#! /bin/bash
apt-get update -y
apt-get install git -y

if ! git diff --no-ext-diff --quiet --exit-code; then
    SSH_PATH="~/.ssh"
    KEY_FILENAME="id_rsa"
    mkdir -p "${SSH_PATH}"
    chmod 700 "${SSH_PATH}"

    echo ${GHA_DEPLOY_KEY} > "${SSH_PATH}/${KEY_FILENAME}"
    chmod 600 "${SSH_PATH}/${KEY_FILENAME}"

    echo -e "Host github.com\n\tIdentityFile ~/.ssh/${KEY_FILENAME}\n\tStrictHostKeyChecking no\n\tAddKeysToAgent yes\n" >> "${SSH_PATH}/config"
    chmod 644 "${SSH_PATH}/config"

    ssh-keyscan github.com >> "${SSH_PATH}/known_hosts"
    chmod 644 "${SSH_PATH}/known_hosts"

    eval `ssh-agent -t 60 -s`
    ssh-add ${SSH_PATH}/${KEY_FILENAME}

    cd public

    git config --local user.name "${GITHUB_ACTOR}"
    git config --local user.email "${GITHUB_ACTOR}@users.noreply.github.com"

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
