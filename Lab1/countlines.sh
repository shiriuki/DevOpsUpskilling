#!/bin/bash
# DevOps upskilling program. Lab #1

countByOwner() {
  echo "Looking for files where the owner is: $1"
  stat -f "%Sp %Su %N" * | grep -E '^-' | cut -c12- | grep -E "^$1" | cut -d ' ' -f 2 | xargs -I % sh -c 'lines=$(cat % | wc -l | tr -d "[:blank:]"); echo "File: %, Lines: $lines"'
}

countByMonth() {
  echo "Looking for files where the month is: $1"
  stat -f "%Sp %Sc %N" * | grep -E '^-' | cut -c12- | grep -E "^$1" | cut -c22- | xargs -I % sh -c 'lines=$(cat % | wc -l | tr -d "[:blank:]"); echo "File: %, Lines: $lines"'
}

usage() {
  echo "$@"
  echo
  echo "For files in current directory count number of lines."
  echo "Usage: $(basename $0) [ -o OWNER | -m MONTH ]" 2>&1
  echo "  -o OWNER: Filter files by OWNER"
  echo "  -m MONTH: Filter files by creation MONTH"
}

exit_abnormal() {
  usage $1
  exit 1
}

if [ $# -eq 0 ]; then
  exit_abnormal "Please enter an option."
fi

unset OWNER MONTH

while getopts ":o:m:" option; do
  case $option in
    o)
      OWNER=$OPTARG
      ;;
    m)
      MONTH=$OPTARG
      ;;
    :)                                   
      exit_abnormal "Option -$OPTARG requires a value."
      ;;
    *)
      exit_abnormal "invalid option: -$OPTARG."
      ;;
  esac
done

shift $(($OPTIND - 1))
if [ -n "$*" ]; then
  exit_abnormal "Invalid entry."
fi

if [ -z "$OWNER" ] && [ -z "$MONTH" ]; then
  exit_abnormal "Invalid entry."
fi

if [ -n "$OWNER" ] && [ -n "$MONTH" ]; then
  exit_abnormal "Please enter only one option."
fi
   
if [ -n "$OWNER" ]; then
  countByOwner $OWNER
fi

if [ -n "$MONTH" ]; then
  countByMonth $MONTH
fi

exit 0