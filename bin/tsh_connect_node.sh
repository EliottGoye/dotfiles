#!/bin/bash

NODE=$(tsh ls | fzf --header-lines=2 | cut -d" " -f1)

if [ -z "$NODE" ]; then
    echo "No node chosen. Exiting..."
else
    tsh ssh "root@$NODE"
fi

exit
