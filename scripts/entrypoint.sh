#!/bin/sh

set -euo pipefail

path="/home/kepubify/files"
file="$path/$1"

/kepubify \
    --verbose \
    --update \
    --output "$path" \
    "$file"
