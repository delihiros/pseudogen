#!/bin/sh

set -eu

BASE_DIR="$(dirname "$(readlink -f "$0")")"

grep -qxF 'FROM ubuntu:24.04' "$BASE_DIR/Dockerfile" || {
    echo "Dockerfile must use Ubuntu 24.04" >&2
    exit 1
}

grep -qF 'python3-nltk' "$BASE_DIR/Dockerfile" || {
    echo "Dockerfile must install python3-nltk" >&2
    exit 1
}

grep -qxF 'ENV USER=root' "$BASE_DIR/Dockerfile" || {
    echo "Dockerfile must set USER for GIZA++" >&2
    exit 1
}

grep -qxF 'COPY . .' "$BASE_DIR/Dockerfile" || {
    echo "Dockerfile must copy the current checkout" >&2
    exit 1
}

if grep -qF 'git clone https://github.com/delihiros/pseudogen.git' "$BASE_DIR/Dockerfile"; then
    echo "Dockerfile must not clone pseudogen" >&2
    exit 1
fi

grep -qF 'd86f8e5dcc3411658bb50bf71a8ff0d9673e783769f9f46d99926fb3b515b7a6' "$BASE_DIR/Dockerfile" || {
    echo "Dockerfile must verify the corpus checksum" >&2
    exit 1
}

grep -qF 'python3-nltk' "$BASE_DIR/README.md" || {
    echo "README must install python3-nltk" >&2
    exit 1
}

grep -qF 'd86f8e5dcc3411658bb50bf71a8ff0d9673e783769f9f46d99926fb3b515b7a6' "$BASE_DIR/README.md" || {
    echo "README must verify the corpus checksum" >&2
    exit 1
}

grep -qF 'docker build -t pseudogen .' "$BASE_DIR/README.md" || {
    echo "README must document the local Docker build" >&2
    exit 1
}

grep -qF 'docker run --rm -it pseudogen' "$BASE_DIR/README.md" || {
    echo "README must document interactive Docker inference" >&2
    exit 1
}

if grep -qF 'pip3 install nltk' "$BASE_DIR/README.md"; then
    echo "README must not install NLTK with pip" >&2
    exit 1
fi

if grep -qF 'docker attach' "$BASE_DIR/README.md"; then
    echo "README must not use the old docker attach flow" >&2
    exit 1
fi

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
