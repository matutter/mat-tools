#!/bin/bash

here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
uuid="da05bebc-bc40-11e7-8199-5b0170596c07"
bashaliases="$(readlink -f ~/.bash_aliases)"
install_file='./.user-install.sh'

##
# creates or appends commands to `install_file`
function add {
  if [ ! -f "$2" ]; then
    echo "(new) $2"
    echo "cp $1 $2" >> "$install_file"
  else
    if ! cmp -s "$1" "$2"; then
      echo "(changed) $2"
      echo "cp $1 $2" >> "$install_file"
    else
      echo "(up to date) $2"
    fi
  fi
}

##
# if `dpkg` returns nothing install the package
function ensure_package {
  if dpkg -l | grep -q "^ii.*$1"; then
    echo "(ok) $1"
  else
    echo "(installing) $1"
    sudo apt install -y "$1"
  fi
}

rm -f "$install_file"
mkdir -p ~/.bin
touch "$bashaliases"

ensure_package "inotify-tools"
ensure_package "lolcat"
ensure_package "cowsay"
ensure_package "fortune"

add aliases.sh           ~/.aliases.sh
add tmux/tmux.conf       ~/.tmux.conf
add tmux/tmux.conf.local ~/.tmux.conf.local
add vimrc ~/.vimrc

for file in $(ls -1 ./scripts); do
  add "./scripts/$file" "/home/$USER/.bin/$file" 
done

if [ -f "$install_file" ]; then
  bash $install_file
else
  echo "nothing to install"
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
