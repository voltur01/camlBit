#!/bin/bash

set -u
set -e

# TODO:check the dependencies

# Clone OMicroB if needed
if [ -d "../OMicroB" ] 
then
    echo "OMicroB already exists."
else
    cd ..
    git clone git@github.com:voltur01/OMicroB.git
    cd OMicroB
    git checkout camlbit
    ./configure
    make
    cd ../camlBit
    # copy the OCaml and OMicroB settings
    cp ../OMicroB/etc/Makefile.conf .
fi
