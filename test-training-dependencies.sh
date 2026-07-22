#!/bin/sh

set -eu

BASE_DIR="$(dirname "$(readlink -f "$0")")"

grep -q -- '-bin_dir \$BASE_DIR/tools/giza-pp' "$BASE_DIR/train-pseudogen.sh" || {
    echo "training must pass GIZA++ to Travatar for alignment" >&2
    exit 1
}

grep -qF 'tail -n 2000 combined.shuf | head -n 1000 > dev.combined' "$BASE_DIR/train-pseudogen.sh" || {
    echo "development data must not overlap training data" >&2
    exit 1
}

for dependency in $(sed -n 's|.*\$BASE_DIR/tools/\([^/ ]*\).*|\1|p' "$BASE_DIR/train-pseudogen.sh" | sort -u); do
    grep -q "/$dependency.git" "$BASE_DIR/tool_setup.sh" || {
        echo "$dependency is used for training but not installed by tool_setup.sh" >&2
        exit 1
    }
done
