#!/bin/bash

# Find and compile all *.gyb files in the Sources directory
find Sources -name '*.gyb' |
    while read file; do
        ./gyb/gyb --line-directive '' -o "$PWD/${file%.gyb}" "$PWD/$file"
	swiftlint --fix --config .swiftlint.yml $PWD/${file%.gyb} 1>/dev/null
    done

# Generate Gtk4 wrapper
swift run GtkCodeGen $(pkg-config --variable=includedir gtk4)/../share/gir-1.0/Gtk-4.0.gir Sources/Gtk/Generated CGtk

# Generate Gtk3 wrapper
swift run GtkCodeGen $(pkg-config --variable=includedir gtk+-3.0)/../share/gir-1.0/Gtk-3.0.gir Sources/Gtk3/Generated CGtk3
