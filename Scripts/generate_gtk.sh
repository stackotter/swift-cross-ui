#!/bin/bash

cd "$(dirname "$0")"

./generate_gtk4.sh
./generate_gtk3.sh
