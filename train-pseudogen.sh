#!/bin/sh

CMDNAME=`basename $0`
BASE_DIR="$(dirname $(readlink -f $0))"
USAGE="Usage: $CMDNAME [-p file] [-e file]"

while getopts p:e: OPT
do
    case $OPT in
        "p" ) P_CHECK="TRUE"; PYTHON_FILE="$OPTARG" ;;
        "e" ) E_CHECK="TRUE"; ENG_FILE="$OPTARG" ;;
        *   ) echo $USAGE 1>&2
              exit 1 ;;
     esac
done

if [ "$P_CHECK" != "TRUE" ] || [ "$E_CHECK" != "TRUE" ]; then
    echo $USAGE 1>&2
    exit 1
fi

echo "tokenizing python ... " 1>&2
python3 $BASE_DIR/scripts/tokenize-py.py < $PYTHON_FILE > $PYTHON_FILE.pytok
echo "tokenizing english ... " 1>&2
python3 $BASE_DIR/scripts/tokenize-en.py < $ENG_FILE > $ENG_FILE.entok
echo "parsing python ... " 1>&2
python3 $BASE_DIR/scripts/parse.py < $PYTHON_FILE > $PYTHON_FILE.rawtree
echo "head insertion ... " 1>&2
python3 $BASE_DIR/scripts/head-insertion.py < $PYTHON_FILE.rawtree > $PYTHON_FILE.headtree
echo "simplifying ... " 1>&2
python3 $BASE_DIR/scripts/simplify.py < $PYTHON_FILE.headtree > $PYTHON_FILE.reducedtree
python3 $BASE_DIR/scripts/filter-data.py $PYTHON_FILE.pytok $ENG_FILE.entok $PYTHON_FILE.reducedtree > all.combined

ALL_DATA_LINE=`wc -l all.combined | awk '{print $1}'`
TRAINING_LINE=`expr  $ALL_DATA_LINE - 2000`

echo "making data ... " 1>&2
shuf all.combined > combined.shuf
cat combined.shuf | head -n $TRAINING_LINE > train.combined
cat combined.shuf | head -n $TRAINING_LINE | tail -1000 > dev.combined
cat combined.shuf | tail -n 1000 > test.combined

for d in train dev test; do
    cut -f 1 $d.combined > $d.pytok
    cut -f 2 $d.combined > $d.entok
    cut -f 3 $d.combined > $d.reducedtree
    python3 $BASE_DIR/scripts/extract_words.py word < $d.reducedtree > $d.reducedsurf
done

echo "making alignment ... " 1>&2
mkdir align
$BASE_DIR/tools/pialign/src/bin/pialign train.reducedsurf train.entok align/align.

echo "making language model ... " 1>&2
mkdir lm
$BASE_DIR/tools/travatar/src/kenlm/lm/lmplz -o 5 < train.entok > lm/lm.arpa
$BASE_DIR/tools/travatar/src/kenlm/lm/build_binary -i lm/lm.arpa lm/lm.blm

echo "training travatar ... " 1>&2
$BASE_DIR/tools/travatar/script/train/train-travatar.pl -work_dir travatar-model -lm_file lm/lm.blm -src_file train.reducedtree -trg_file train.entok -travatar_dir $BASE_DIR/tools/travatar -bin_dir $BASE_DIR/tools/giza-pp -threads 2

echo "tuning travatar ... " 1>&2
$BASE_DIR/tools/travatar/script/mert/mert-travatar.pl -travatar-config travatar-model/model/travatar.ini -nbest 100 -src dev.reducedtree -ref dev.entok -travatar-dir $BASE_DIR/tools/travatar -working-dir tune
