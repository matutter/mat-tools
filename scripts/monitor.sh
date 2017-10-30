#!/bin/bash

function find_files {
  find -type f -name '*.([ch]|js|py)' | tr '\n' ' '
}

cmd="$@"

if [ -z "$cmd" ]; then
  echo 'Empty command, nothing to do...'
  exit
fi

while :; do

  files=$(find_files)

  echo "$(date +%s) watching > $files"  
  inotifywait -qq -e modify $files

  if [[ $? -eq 0 ]]; then
    echo "$(date +%s) running > $cmd"
    $cmd
  fi

  sleep 1
done

