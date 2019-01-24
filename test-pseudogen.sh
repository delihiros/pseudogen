#!/bin/sh

CMDNAME=`basename $0`
BASE_DIR="$(dirname $(readlink -f $0))"
USAGE="Usage: $CMDNAME [-r file] [-h file]"

while getopts r:h: OPT
do
    case $OPT in
        "r" ) R_CHECK="TRUE"; REF_FILE="$OPTARG" ;;
        "h" ) H_CHECK="TRUE"; HYP_FILE="$OPTARG" ;;
        *   ) echo $USAGE 1>&2
              exit 1 ;;
     esac
done

if [ "$R_CHECK" != "TRUE" ] || [ "$H_CHECK" != "TRUE" ]; then
    echo $USAGE 1>&2
    exit 1
fi

$BASE_DIR/tools/mteval/build/bin/mteval-corpus -e BLEU RIBES -r $REF_FILE -h $HYP_FILE
