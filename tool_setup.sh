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
sed -i -e "36 s/.*/CPPFLAGS=\"\$CPPFLAGS -std=c++11\"/" configure.ac
autoreconf -i
./configure
make -j`nproc`
cd ..

## install mteval
### required for evaluation

git clone https://github.com/odashi/mteval.git
cd mteval
mkdir build
cd build
cmake ..
make -j`nproc`
cd ..

cd ..

cd .. 
