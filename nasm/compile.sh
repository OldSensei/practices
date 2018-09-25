#!/bin/bash

if [ $# -lt 2 ]; then
    echo 'Count of arguments is less then 3'
    exit 1
fi

sourcefile="$1.asm"
objectfile="$1.o"
executablefile=$2

echo Start assambly of $sourcefile:

nasm -f elf $sourcefile

if [ ! -s $objectfile ]; then
    echo Can not assembly
    exit 1
fi

echo Success
echo Start linking $executablefile:

ld -m elf_i386 -s -o $executablefile $objectfile  

if [ -s $executablefile ]; then
    echo Success
fi

echo Remove $objectfile

rm $objectfile
