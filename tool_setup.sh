#!/bin/bash -e

# tool setup

mkdir tools
cd tools

## install giza++
### required for making alignment between languages

git clone https://github.com/moses-smt/giza-pp.git
cd giza-pp
make -j`nproc`
cp GIZA++-v2/GIZA++ GIZA++-v2/*.out mkcls-v2/mkcls .
cd ..

## install travatar
### required for Tree-to-String machine translation

git clone https://github.com/neubig/travatar.git
cd travatar
autoreconf -i
./configure
make -j`nproc`

cd ..

## install mteval
### required for evaluation

git clone https://github.com/odashi/mteval.git
cd mteval
autoreconf -i
./configure
make -j`nproc`

cd ..

cd .. 
