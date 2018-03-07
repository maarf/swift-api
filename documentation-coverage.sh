#!/bin/bash

coverage="$(cat 'docs/undocumented.json' | jq '.warnings | length')"

if [ $coverage != 0 ]
then
  echo "Code isn't documented with 100%"
  warnings="$(cat 'docs/undocumented.json' | jq '.warnings')"
  echo "Warnings:"
  echo $warnings
  exit 1
else
  echo "Code documented with 100%"
fi
