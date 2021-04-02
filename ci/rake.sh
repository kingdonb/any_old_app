#!/bin/bash

# ./ci/rake.sh
set -feux   # Usage: $0 <BRANCH>   # Fails when BRANCH is not provided
BRANCH=$1

# The output/ directory is listed in .gitignore, where jsonnet rendered output.
pushd output

# Fetch git branch 'deploy' and run `git checkout deploy`
/usr/bin/git -c protocol.version=2 fetch \
        --no-tags --prune --progress --no-recurse-submodules \
        --depth=1 origin $BRANCH
git checkout $BRANCH --

# Prepare the output to commit by itself in the deploy branch's root directory.
mv -f ./production.yaml ../    # Overwrite any existing files (no garbage collection here)
git diff

# All done (the commit will take place in the next action!)
popd
