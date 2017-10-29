#!/bin/bash

here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
uuid="da05bebc-bc40-11e7-8199-5b0170596c07"
bashrc="/home/$USER/.bashrc"

function to_home {
  cp "$here/$1" "/home/$USER/$2"
}

to_home aliases.sh .aliases.sh

if ! grep -q "$uuid" "$bashrc"; then

  cat > "$bashrc" <<EOL
  ##
  # $uuid
  source /home/$USER/.aliases.sh
  EOL

fi
