#!/bin/bash

function find_files {
  find -type f -regextype posix-extended -regex '.*.([ch]|js|py)' -not -path '*/\.*' \
   | tr '\n' ' '
}

cmd="$@"

if [ -z "$cmd" ]; then
  echo 'Empty command, nothing to do...'
  exit
fi

bgpid=0
files=$(find_files)
echo "$(date +%s) watching > $files"  
while :; do


  inotifywait -qq -e modify $files

  if [ $bgpid -ne 0 ]; then
    kill -9 $bgpid
  fi

  files=$(find_files)
  echo "$(date +%s) watching > $files"  

  if [[ $? -eq 0 ]]; then
    echo "$(date +%s) running > $cmd"
    $cmd &
    bgpid=$!
  fi

  sleep 1
done

