#!/bin/bash
#set -x
if [ ! -d ~/.bpmdj ]; then
        # create needed directories
        mkdir -p  ~/.bpmdj/fragments
        mkdir -p  ~/.bpmdj/index
        mkdir -p  ~/.bpmdj/music
        # link application to user-directory
        ln -sf /usr/lib/bpmdj/* ~/.bpmdj
        ln -sf /usr/lib/bpmdj/sequences ~/.bpmdj
fi

export PATH=~/.bpmdj:$PATH
# start programm from user-directory
(cd ~/.bpmdj && ./bpmdj)
