#!/bin/bash

# This script compiles all .gyb files in the Sources directory

find Sources -name '*.gyb' |
    while read file; do
        ./gyb/gyb --line-directive '' -o "$PWD/${file%.gyb}" "$PWD/$file"
	swiftlint --fix --config .swiftlint.yml $PWD/${file%.gyb} 1>/dev/null
    done

swift run GtkCodeGen $(pkg-config --variable=includedir gtk4)/../share/gir-1.0/Gtk-4.0.gir Sources/Gtk/Generated
