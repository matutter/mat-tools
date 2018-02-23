#!/bin/bash

function find_files {
  find -type f -regextype posix-extended -regex '.*.([ch]|js|py|cc|cpp)' -not -path '*/\.*' \
   | tr '\n' ' '
}

cmd="$@"

if [ -z "$cmd" ]; then
  echo 'Empty command, nothing to do...'
  exit
fi

function on_kill {
  echo -e "\rStopping monitor..."
  pkill -P $$
  exit 0
}

trap 'on_kill' SIGINT

bgpid=0
files=$(find_files)
echo "$(date +%s) watching > $files"  
while :; do


  inotifywait -qq -e modify $files

  if [ $bgpid -ne 0 ]; then
    pkill -P $$
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

