#!/bin/bash

coverage="$(cat 'docs/undocumented.json' | jq '.warnings | length')"

if [ $coverage != 0 ]
then
  exit 65
else
  echo "Code documented with 100%"
fi
