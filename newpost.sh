#!/bin/bash
category=$2

if [[ -z ${category} ]]; then
  category=""
fi
if [[ -z $1 ]]; then
  echo name not specific
  exit 1
fi
hugo new content/post/"${category}"/"$1"/index.md
# exist category
if [[ -n ${category} ]]; then
  sed -i "" "s/未分类/${category}/g" "content/post/${category}/$1/index.md"
fi
code "content/post/${category}/$1/index.md"
