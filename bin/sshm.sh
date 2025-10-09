#!/bin/bash

tsh ls -f json --all | python3 "${HOME}/dotfiles/bin/tsh_to_ssh_config.py" > "${HOME}/.ssh/config.d/sshm"
sshm
