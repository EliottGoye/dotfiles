# Path to your oh-my-zsh installation.
export ZSH=/home/eliott/.oh-my-zsh

PATH=/home/eliott/.local/bin:$PATH
#TERM="xterm-256color"

# ZSH theme
export ZSH_THEME="agnoster"

export REGISTRY_NAME='ci.docapost.io'
export EDITOR='vim'

eval "$(direnv hook zsh)"

# ZSH plugins
export plugins=(git autojump cp ansible kubectl)

source $ZSH/oh-my-zsh.sh

# Set default Tmux pane name
if [[ -v TMUX ]]; then tmux rename-window -t "${TMUX_PANE}" 'local'; fi

# Short prompt
prompt_context() {
    if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
        prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
    fi
}

# Change tmux pane name on ssh connect
s() {
    hostname="$1"
    args="$*[2,-1]"
    if [[ -v TMUX ]]; then tmux rename-window -t "${TMUX_PANE}" "${${hostname#root@}%.smartpanda.eu}"; fi
    command ssh "$@"
    if [[ -v TMUX ]]; then tmux rename-window -t "${TMUX_PANE}" "local"; fi
}

# Connect with my tmux conf
ssht() {
    hostname="$1"
    if [[ -v TMUX ]]; then tmux rename-window -t "${TMUX_PANE}" "${${hostname#root@}%.smartpanda.eu}"; fi
    scp -q ~/.tmux.conf "${hostname}:~/"
    command ssh -t "${hostname}" "which tmux || apt-get install -y tmux && tmux"
    command ssh "${hostname}" rm .tmux.conf
    if [[ -v TMUX ]]; then tmux rename-window -t "${TMUX_PANE}" "local"; fi
}

# SSH auto-completion
h=()
if [[ -r ~/.ssh/config ]]; then
    h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
if [[ -r ~/.ssh/known_hosts ]]; then
    h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
fi
if [[ $#h -gt 0 ]]; then
    zstyle ':completion:*:s:*' hosts ${h}
    zstyle ':completion:*:ssh:*' hosts ${h}
    zstyle ':completion:*:slogin:*' hosts ${h}
fi


# Tmux pane ID variable
export tmuxId="$(($(tmux display -pt "${TMUX_PANE:?}" "#{pane_index}") + 1))" 2> /dev/null

# Tons of aliases
alias ip='ip --color'
alias ipb='ip --color --brief'

alias k='kubectl'
alias kx='kubectx'
alias kn='kubens'

alias tx='tsh login $(tsh clusters | fzf-tmux --header-lines=2 | cut -d" " -f1)'
alias ts='tsh ssh root@$(tsh ls -f names | fzf)'

alias ez="vi ~/.zshrc"
alias ev="vi ~/.vimrc"
alias et="vi ~/.tmux.conf"
alias ek="vi ~/.kube/config"
alias es="vi ~/.config/espanso/default.yml"

alias l='k -ah'
alias fu='sudo $(fc -ln -1)'
alias h='sudo vi /etc/hosts'
alias v='vim +:NERDTree'
alias t='tmux'
alias st='ssht'
alias i='curl ifconfig.co/ip'
alias c='code .'
alias gw='./gradlew'
alias u='sudo apt-get update && sudo apt-get dist-upgrade -y'

alias gd='git diff --ignore-space-change'
alias git unreset="git reset 'HEAD@{1}'"
alias git-ssh='git remote set-url origin "$(git remote get-url origin | sed -E '\''s,^https://([^/]*)/(.*)$,git@\1:\2,'\'')"'
alias git-https='git remote set-url origin "$(git remote get-url origin | sed -E '\''s,^git@([^:]*):/*(.*)$,https://\1/\2,'\'')"'

alias npbr='npm run build && npm run start'

alias ap='ansible-playbook'

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin
export N_PREFIX=$HOME/.n
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/"
source "$HOME/.cargo/env"

source <(kubectl completion zsh)
compdef __start_kubectl k

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"
[ -f "$HOME/dotfiles/zsh/tsh.zsh" ] && source "$HOME/dotfiles/zsh/tsh.zsh"

eval "$(_DA_CLI_COMPLETE=zsh_source da-cli)"

_fzf_complete_tsh() { _fzf_complete --height=60% --info=inline --border --margin=1 --padding=1 -- "tsh ssh root@$2" < <( tsh ls -f names ) }
