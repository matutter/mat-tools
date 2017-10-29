#!/bin/bash

here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
uuid="da05bebc-bc40-11e7-8199-5b0170596c07"
bashaliases="$(readlink -f ~/.bash_aliases)"

function to_home {
  src="$here/$1"
  dst="/home/$USER/$2"

  if cmp --silent $src $dst; then
    echo "[ ] $dst"
  else
    echo "[new] $dst"
    cp "$src" "$dst"
  fi
}

to_home aliases.sh .aliases.sh

if [ ! -f "$bashaliases" ]; then
  touch "$bashaliases"
fi

if ! grep -q "$uuid" "$bashaliases"; then

  echo "Inserting snippet into $bashaliases"
  echo "
    ##
    # $uuid
    source ~/.aliases.sh
  " | sed -e 's/^[ \t]*//' >> "$bashaliases"

fi


source ~/.bashrc 