#!/bin/bash

pidfile="/home/$USER/.ssh-agent.pid"
create_session=false

if [ -f "$pidfile" ]; then
  echo "Attempting to restore session"
  source "$pidfile"
  
  if [ ! -S "$SSH_AUTH_SOCK" ]; then
    echo "! SSH_AUTH_SOCK ($SSH_AUTH_SOCK) does not exit"
    create_session=true
  fi
  
  if [ $? -ne 0 ]; then
    echo "! Agent is no logner running..."
    create_session=true
  fi
else
  create_session=true
fi

if $create_session; then
  echo "> Creating new session"
  eval `ssh-agent -s | tee $pidfile`
  for f in ~/.ssh/*.pub; do
    ssh-add ${f%.*}
  done
fi

ssh-add -l
