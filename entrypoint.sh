#!/usr/bin/env zsh
set -e

git pull
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
