#!/bin/bash

venv_script=$(find -type f -name activate -print -quit)

if [ -z "$venv_script" ]; then
  echo '! No virtual environment found in $(pwd)'
else
  echo "(ok) sourcing $venv_script"
  source "$venv_script"
fi

