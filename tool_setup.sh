# tool setup

mkdir tools
cd tools

## install giza++
### required for making alignment between languages

git clone https://github.com/moses-smt/giza-pp.git
cd giza-pp
make
cp GIZA++-v2/GIZA++ GIZA++-v2/*.out mkcls-v2/mkcls .
cd ..

## install travatar
### required for Tree-to-String machine translation

git clone https://github.com/neubig/travatar.git
cd travatar
autoreconf -i
./configure
make

cd ..

##  install kenlm
### required for making language model

git clone https://github.com/kpu/kenlm.git
cd kenlm
./bjam -j4

cd ..

## install mteval
### required for evaluation

git clone https://github.com/odashi/mteval.git
cd mteval
autoreconf -i
./configure
make

cd ..

## install pialign
### not really necessary, but can be used to make alignment

git clone https://github.com/neubig/pialign.git
cd pialign
autoreconf -i
./configure
make

cd ..

cd .. 
