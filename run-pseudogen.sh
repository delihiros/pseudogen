#!/bin/sh

CMDNAME=`basename $0`
BASE_DIR="$(dirname $(readlink -f $0))"
USAGE="Usage: $CMDNAME [-f file]"

while getopts f: OPT
do
    case $OPT in
        "f" ) F_CHECK="TRUE"; CONFIG_FILE="$OPTARG" ;;
        *   ) echo $USAGE 1>&2
              exit 1 ;;
     esac
done

$BASE_DIR/tools/travatar/src/bin/travatar -config_file $CONFIG_FILE
