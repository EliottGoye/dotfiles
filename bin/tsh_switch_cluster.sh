#!/bin/bash

CLUSTER=$(tsh clusters | fzf --header-lines=2 | cut -d" " -f1)

if [ -z "$CLUSTER" ]; then
    echo "No cluster chosen. Exiting..."
else
    echo "Switching to $CLUSTER"
    tsh login "$CLUSTER"
fi