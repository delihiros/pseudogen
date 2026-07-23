FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root

RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    autotools-dev \
    build-essential \
    ca-certificates \
    cmake \
    git \
    libboost-all-dev \
    libtool \
    python3 \
    python3-nltk \
    wget \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /pseudogen
COPY . .

RUN ./tool_setup.sh && \
    mkdir data && \
    cd data && \
    wget -O en-django.tar.gz http://ahclab.naist.jp/pseudogen/en-django.tar.gz && \
    echo 'd86f8e5dcc3411658bb50bf71a8ff0d9673e783769f9f46d99926fb3b515b7a6  en-django.tar.gz' | sha256sum -c - && \
    tar -xzf en-django.tar.gz && \
    mv en-django/all.* . && \
    ../train-pseudogen.sh -p all.code -e all.anno && \
    test -s tune/travatar.ini

WORKDIR /pseudogen/data
CMD ["../run-pseudogen.sh", "-f", "tune/travatar.ini"]
