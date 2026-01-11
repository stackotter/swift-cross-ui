#!/bin/bash

cd "$(dirname "$0")"/../

# Find and compile all *.gyb files in the Sources directory
find Sources -name '*.gyb' |
  while read file; do
    ./gyb/gyb --line-directive '' -o "$PWD/${file%.gyb}" "$PWD/$file"
    ./Scripts/format.sh $PWD/${file%.gyb}
  done
