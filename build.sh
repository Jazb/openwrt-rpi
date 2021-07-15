#!/bin/bash
cd src
make menuconfig
make -j1 V=sc
