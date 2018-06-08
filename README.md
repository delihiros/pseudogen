# Pseudogen

A tool to automatically generate pseudo-code from source code.

[Demo](http://ahclab.naist.jp/pseudogen/)

## Installation

### Using Docker

docker is all you need.

```
  docker attach `docker run -itd delihiros/pseudogen`
  /# cd pseudogen/data
  /# ../run-pseudogen.sh -f tune/travatar.ini
```

### Requirements

Requires Python 3.5+

```
  apt install git libboost-all-dev autoconf automake autotools-dev libtool zlib1g-dev cmake build-essential python3 python3-pip wget -y
  pip3 install nltk
```

*for Mac OS X users*:
`GIZA++` is written for Linux, so you may need to do some modifications to install.
http://catherinegasnier.blogspot.jp/2014/04/install-giza-107-on-mac-osx-1092.html

```
  git clone https://github.com/delihiros/pseudogen.git
  cd pseudogen
  ./tool_setup.sh
```

## Usage

Download and extract corpus from annotated Django source code.

```
  mkdir data
  cd data
  wget -O- http://ahclab.naist.jp/pseudogen/en-django.tar.gz | tar zxvf -
  mv en-django/all.* .
```

```
  ../train-pseudogen.sh -p all.code -e all.anno
  ../run-pseudogen.sh -f tune/travatar.ini
  # input Python code you want to translate
  # in some environments, you may need to press Ctrl+D few times in order to start tranlating
```


## How does Pseudogen work?

### Papers

+ [Methods - IEEE/ACM ASE 2015](http://www.phontron.com/paper/oda15ase.pdf)
+ [Software - IEEE/ACM ASE 2015](http://www.phontron.com/paper/fudaba15asedemo.pdf)

### Tools Used

+ `GIZA++` to make alignment
+ `Travatar` to train Tree-to-String machine translation model
+ `mteval` to evaluate

## Contributors

+ [Yusuke Oda](http://odaemon.com)
+ [Hiroyuki Fudaba](http://delihiros.jp)
+ [Koichi Akabe](http://isw3.naist.jp/~koichi-a/)
+ [Graham Neubig](http://phontron.com/)
+ [Hideaki Hata](http://isw3.naist.jp/~hata/)
