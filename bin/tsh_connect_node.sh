#!/bin/bash

NODE=$(tsh ls | fzf --header-lines=2 | cut -d" " -f1)

if [ -z "$NODE" ]; then
    echo "No node chosen. Exiting..."
else
    tmux rename-window -t "${TMUX_PANE}" "$NODE"
    tsh ssh "root@$NODE"
    tmux rename-window -t "${TMUX_PANE}" "local"
fi

exit
