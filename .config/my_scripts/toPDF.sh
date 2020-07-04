#!/bin/bash

if [[ $# != 2 ]]; then
    echo "Need 2 arguments: input.md file and output.pdf(to be created)"
    exit 1
fi

pandoc "$1" \
    -V colorlinks \
    -V geometry:"margin=2.5cm" \
    -V geometry:a4paper \
    -V mainfont="DejaVu Serif" \
    -V monofont="DejaVu Sans Mono" \
    --highlight-style ~/.config/my_scripts/pygments.theme \
    --include-in-header ~/.config/my_scripts/inlineCode.tex \
    --pdf-engine=xelatex \
    -o "$2"

