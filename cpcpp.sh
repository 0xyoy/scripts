#!/bin/sh

# c++ programming contest directory setup

TEMPLATE="/Users/ania/code/comp/s.cpp"

for problem in "$@"
do
    mkdir "$problem"
    cp "$TEMPLATE" "$problem"/
done
