#!/usr/bin/env bash

# Please Use Google Shell Style: https://google.github.io/styleguide/shell.xml

# ---- Start unofficial bash strict mode boilerplate
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -o errexit  # always exit on error
set -o errtrace # trap errors in functions as well
set -o pipefail # don't ignore exit codes when piping output
set -o posix    # more strict failures in subshells
# set -x          # enable debugging

IFS=$'\n\t'
# ---- End unofficial bash strict mode boilerplate

# outputs each tag we're attaching to this docker image
SHA="${1:-HEAD}"
BRANCH=$2
SHA1=$(git rev-parse --verify "${SHA}")

# Echo to stderr
echoerr() { echo "$@" 1>&2; }

# Ensure that git SHA was provided
if [[ -x "${SHA1}" ]]; then
    echoerr "Error, no git SHA provided"
    exit 1
fi

# tag with the branch
if [[ -n "${BRANCH}" ]]; then
    echo "${BRANCH}"
fi

# Tag with each git tag
if git show-ref --tags -d | grep "^${SHA1}" 2>/dev/null; then
    # TODO: get better this validation
    git show-ref --tags -d |
    grep "^${SHA1}" |
    sed -e 's,.* refs/tags/,,' -e 's/\^{}//' 2>/dev/null |
    xargs -I % echo "%"
fi

# Tag with latest if certain conditions are met
if [[ "$BRANCH" == "master" ]]; then
    echo "latest"
fi