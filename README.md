# Pseudogen

A tool to automatically generate pseudo-code from source code.

[Demo](http://ahclab.naist.jp/pseudogen/)

## Installation

  $ git clone https://github.com/delihiros/pseudogen.git
  $ cd pseudogen
  $ ./tool_setup.sh

## Usage

  $ mkdir data
  $ cd data
  $ wget -O- http://ahclab.naist.jp/en-django.tar.gz | tar zxvf -
  $ ./../train-pseudogen.sh -p all.code -e all.anno
  $ ./..//run-pseudogen.sh -f tune/travatar.ini < test.reducedtree > test.out
  $ ./../test-pseudogen.sh -r test.entok -h test.out

## Requirements
  
  $ sudo apt-get install git libboost-all-dev autoconf automake autotools-dev libtool
  $ pip install nltk

## How does Pseudogen work?

### Papers

[Methods - IEEE/ACM ASE 2015](http://www.phontron.com/paper/oda15ase.pdf)
[Software - IEEE/ACM ASE 2015](http://www.phontron.com/paper/fudaba15asedemo.pdf)

### Architecture

### Tools Used

+ `GIZA++` to make alignment
+ `Travatar` to train Tree-to-String machine translation model
+ `KenLM` to make language model
+ `mteval` to evaluate

## Contributors

+ [Yusuke Oda](http://odaemon.com)
+ [Hiroyuki Fudaba](http://delihiros.github.io)
