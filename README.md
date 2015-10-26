# Pseudogen

A tool to automatically generate pseudo-code from source code.

[Demo](http://ahclab.naist.jp/pseudogen/)

## Installation

### Requirements

```
  $ sudo apt-get install git libboost-all-dev autoconf automake autotools-dev libtool
  $ pip install nltk
```

*for Mac OS X users*:
`GIZA++` is written for Linux, so you may need to do some modifications to install.
http://catherinegasnier.blogspot.jp/2014/04/install-giza-107-on-mac-osx-1092.html

```
  $ git clone https://github.com/delihiros/pseudogen.git
  $ cd pseudogen
  $ ./tool_setup.sh
```

## Usage

Download and extract corpus from annotated Django source code.

```
  $ mkdir data
  $ cd data
  $ wget -O- http://ahclab.naist.jp/pseudogen/en-django.tar.gz | tar zxvf -
```

Call extracted data as `all.code` and `all.anno`.

```
  $ ./../train-pseudogen.sh -p all.code -e all.anno
  $ ./../run-pseudogen.sh -f tune/travatar.ini < test.reducedtree > test.out
  $ ./../test-pseudogen.sh -r test.entok -h test.out
```


## How does Pseudogen work?

### Papers

+ [Methods - IEEE/ACM ASE 2015](http://www.phontron.com/paper/oda15ase.pdf)
+ [Software - IEEE/ACM ASE 2015](http://www.phontron.com/paper/fudaba15asedemo.pdf)

### Architecture

### Tools Used

+ `GIZA++` to make alignment
+ `Travatar` to train Tree-to-String machine translation model
+ `mteval` to evaluate

## Contributors

+ [Yusuke Oda](http://odaemon.com)
+ [Hiroyuki Fudaba](http://delihiros.github.io)
+ [Koichi Akabe](http://isw3.naist.jp/~koichi-a/)
+ [Graham Neubig](http://phontron.com/)
+ [Hideaki Hata](http://isw3.naist.jp/~hata/)
