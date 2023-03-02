#!/bin/sh

# c++ programming contest directory setup

for problem in "$@"
do
    mkdir "$problem"
    cd "$problem"
    cptemplate_cpp.sh
    cd ..
done
