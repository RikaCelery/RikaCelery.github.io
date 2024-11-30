#!/bin/bash

if [[ -z $1 ]]; then
  echo name not specific
  exit 1
fi
hugo new content/categories/"$1"/_index.md
code content/categories/"$1"/_index.md
