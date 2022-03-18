#!/bin/bash

# This script compiles all .gyb files in the Sources directory

find Sources -name '*.gyb' | \
    while read file; do \
        ./gyb/gyb --line-directive '' -o "$PWD/${file%.gyb}" "$PWD/$file"; \
    done
