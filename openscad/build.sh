#!/bin/bash
# =========================================================================
# STL Build Script for OpenSCAD Display Enclosure
# =========================================================================
set -e

# Change to the directory of the script to ensure paths are correct
cd "$(dirname "$0")"

echo "Creating 'dist' output directory..."
mkdir -p dist

echo "Building Front Cover (dist/front_cover.stl)..."
openscad -o dist/front_cover.stl -D "part_to_render=1" enclosure.scad

echo "Building Rear Cover (dist/rear_cover.stl)..."
openscad -o dist/rear_cover.stl -D "part_to_render=2" enclosure.scad

echo "Building Combined Print Layout (dist/print_layout.stl)..."
openscad -o dist/print_layout.stl -D "part_to_render=0" enclosure.scad

echo "========================================================================="
echo "Successfully built STL files in 'openscad/dist/'!"
echo "Files generated:"
echo "  - openscad/dist/front_cover.stl (Front Cover, face-down)"
echo "  - openscad/dist/rear_cover.stl (Rear Cover, back-down)"
echo "  - openscad/dist/print_layout.stl (Both parts pre-arranged for printing)"
echo "========================================================================="
