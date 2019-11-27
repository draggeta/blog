#! /bin/bash
if ! git diff --no-ext-diff --quiet --exit-code; then
    SSH_PATH="~/.ssh"
    KEY_FILENAME="id_rsa2"
    mkdir -p "${SSH_PATH}"
    chmod 700 "${SSH_PATH}"

    echo ${GHA_DEPLOY_KEY} > "${SSH_PATH}/${KEY_FILENAME}"
    cat "${SSH_PATH}/${KEY_FILENAME}"
    chmod 600 "${SSH_PATH}/${KEY_FILENAME}"

    whoami
    eval `ssh-agent -t 60 -s`
    ssh-add ${SSH_PATH}/${KEY_FILENAME}

    cd public
    pwd

    git config --local user.name "${GITHUB_ACTOR}"
    git config --local user.email "${GITHUB_ACTOR}@users.noreply.github.com"
    git config user.name
    git config user.email
    git add .
    echo -n 'Files to Commit:' && ls -l | wc -l
    timestamp=$(date +%s%3N)
    git commit -a -m "Automated deployment to GitHub Pages on $timestamp"
    # echo

    echo "Done!"
fi
