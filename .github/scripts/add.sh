#!/bin/sh

# abort if any command fails
set -e

# add required packages for git to run
apk add --update git openssh-client bash git-subtree ca-certificates
+

git submodule add -b master git@github.com:draggeta/draggeta.github.io.git public

echo "Done!"
