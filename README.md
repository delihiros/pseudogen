# Pseudogen

Pseudogen generates English pseudocode descriptions from Python source code. It supports local Docker builds and manual installation on Ubuntu 24.04. Try the [Pseudogen demo](http://ahclab.naist.jp/pseudogen/).

## Install with Docker

Use Docker to build the current checkout, train the model, and run inference:

1. Install [Docker](https://docs.docker.com/engine/install/).
2. Clone this repository:

   ```bash
   git clone https://github.com/delihiros/pseudogen.git
   cd pseudogen
   ```

3. Build the image:

   ```bash
   docker build -t pseudogen .
   ```

   The build compiles the tools, downloads and verifies the corpus, and trains the model.

4. Start interactive inference:

   ```bash
   docker run --rm -it pseudogen
   ```

   Enter Python source code, then press Ctrl-D to end input.

Run a non-interactive inference command when you already have the input:

```bash
printf 'x += 1\n' | docker run --rm -i pseudogen
```

## Install manually on Ubuntu 24.04

Install the build and runtime dependencies on Ubuntu 24.04:

```bash
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  autoconf automake autotools-dev build-essential ca-certificates cmake git \
  libboost-all-dev libtool python3 python3-nltk wget zlib1g-dev
```

Clone the repository and compile the bundled tools:

```bash
git clone https://github.com/delihiros/pseudogen.git
cd pseudogen
./tool_setup.sh
```

## Download the training corpus

Create the `data` directory, download the annotated Django corpus, and verify its SHA-256 checksum:

```bash
mkdir data
cd data
wget -O en-django.tar.gz http://ahclab.naist.jp/pseudogen/en-django.tar.gz
echo 'd86f8e5dcc3411658bb50bf71a8ff0d9673e783769f9f46d99926fb3b515b7a6  en-django.tar.gz' | sha256sum -c -
tar -xzf en-django.tar.gz
mv en-django/all.* .
```

## Train the model

Run training from the `data` directory:

```bash
../train-pseudogen.sh -p all.code -e all.anno
```

Training creates the model configuration at `tune/travatar.ini`.

## Evaluate the model

Run evaluation from the `data` directory:

```bash
../tools/travatar/src/bin/travatar -threads 2 -config_file tune/travatar.ini < test.reducedtree > test.hyp
../test-pseudogen.sh -r test.entok -h test.hyp
```

The first command generates translations. The second reports BLEU and RIBES scores.

## Run inference manually

Run a single inference from the `data` directory:

```bash
printf 'x += 1\n' | ../run-pseudogen.sh -f tune/travatar.ini
```

You can also run `../run-pseudogen.sh -f tune/travatar.ini` interactively. Enter Python source code, then press Ctrl-D to end input.

## How Pseudogen works

Pseudogen aligns Python and English training data, then trains a tree-to-string machine translation model.

### Papers

- [Methods, IEEE/ACM ASE 2015](http://www.phontron.com/paper/oda15ase.pdf)
- [Software, IEEE/ACM ASE 2015](http://www.phontron.com/paper/fudaba15asedemo.pdf)

### Tools used

- `GIZA++` creates alignments
- `Travatar` trains the tree-to-string machine translation model
- `mteval` evaluates translations

## Contributors

- [Yusuke Oda](http://odaemon.com)
- [Hiroyuki Fudaba](http://delihiros.jp)
- [Koichi Akabe](http://isw3.naist.jp/~koichi-a/)
- [Graham Neubig](http://phontron.com/)
- [Hideaki Hata](http://isw3.naist.jp/~hata/)
