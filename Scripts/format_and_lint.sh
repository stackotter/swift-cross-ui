#!/bin/bash

cd "$(dirname "$0")"/../

./Scripts/format.sh
swiftlint lint --quiet
