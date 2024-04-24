#!/usr/bin/env bash

set -euo pipefail

input="${1?input file required}"

printf "Mounted %s --> /home/kepubify/files\n" "$(pwd)"

docker run \
    -v "$(pwd)":/home/kepubify/files \
    --rm kwbr/docker-kepubify \
    "$input"
