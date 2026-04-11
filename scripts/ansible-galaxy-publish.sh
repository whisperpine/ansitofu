#!/bin/sh

# Purpose: build the ansible collection and push to ansible galaxy
# Usage: sh path/to/ansible-galaxy-publish.sh
# Dependencies: ansible-galaxy, jq
# Date: 2026-04-12
# Author: Yusong

set -e

if [ -z "$ANSIBLE_GALAXY_API_TOKEN" ]; then
  echo "Error: Environment variable ANSIBLE_GALAXY_API_TOKEN must be set."
  echo "Hints: It should be configured in 'encrypted.env' and exposed by '.envrc'."
  exit 1
fi

# The version of the collection.
version=$(ansible-galaxy collection list |
  awk '$1 == "whisperpine.ansitofu" { print $2 }')
# The file path of
artifact_file="whisperpine-ansitofu-$version.tar.gz"

# Builds the artifact.
ansible-galaxy collection build --force "whisperpine/ansitofu"

if [ ! -f "$artifact_file" ]; then
  echo "Error: Cannot find '$artifact_file' after building."
  exit 1
fi

# Pushes to ansible galaxy.
ansible-galaxy collection publish "$artifact_file" \
  --api-key "$ANSIBLE_GALAXY_API_TOKEN"
