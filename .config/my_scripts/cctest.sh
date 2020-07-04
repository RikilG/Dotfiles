#!/bin/bash

Help="syntax: cctest.sh path/to/program.cpp path/to/input.txt path/to/output.txt"

if [[ $# != 3 ]]; then
    echo $Help
    exit 0
fi

if [[ ! -f $1 || ! -f $2 || ! -f $3 ]]; then
    echo "One of the parameter appears to be invalid file path. please check"
    echo $Help
    exit 0
fi
