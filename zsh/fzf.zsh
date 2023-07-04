[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"


_fzf_complete_tsh() {
    ARGS="$*"
    if [[ $ARGS == 'tsh ssh'* ]]; then
        _fzf_complete --bind 'start:execute-silent(echo {q} > /tmp/tsh_user)+clear-query' --height=60% --info=inline --border --margin=1 --padding=1 -- "$@" < <( tsh ls -f names )
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}

_fzf_complete_tsh_post() {
    awk -v user=$(cat /tmp/tsh_user) '{print user $NF}'
}

_fzf_complete_git() {
    ARGS="$*"
    if [[ $ARGS == 'git checkout'* ]]; then
        _fzf_complete -- "$@" < <( git branch --all )
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}