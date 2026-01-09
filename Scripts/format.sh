#!/bin/bash

cd "$(dirname "$0")"/../

if [ -z "$1" ]; then
  swift format format --in-place --recursive --configuration .swift-format Sources Examples/Sources
else
  swift format format --in-place --recursive --configuration .swift-format $1
fi
