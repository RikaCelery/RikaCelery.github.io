#!/bin/bash
category=$2

if [[ -z $category ]]; then
  category=""
fi
if [[ -z $1 ]]; then
  echo name not specific
  exit 1
fi
hugo new content/post/"$category""$1"/index.md
code content/post/"$category""$1"/index.md
