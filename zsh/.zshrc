# Path to your oh-my-zsh installation.
export ZSH=/home/eliott/.oh-my-zsh

PATH=/home/eliott/.local/bin:$PATH
#TERM="xterm-256color"

# ZSH theme
export ZSH_THEME="agnoster"
export EDITOR='vim'

eval "$(direnv hook zsh)"

# Enable vim keybindings
bindkey -v

# ZSH plugins
export plugins=(git autojump cp ansible kubectl)

source $ZSH/oh-my-zsh.sh

# Set default Tmux pane name
if [[ -v TMUX ]]; then
  tmux rename-window -t "${TMUX_PANE}" 'local'
else
  tmux attach || tmux
fi

# Short prompt
prompt_context() {
    if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
        prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
    fi
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

# Tmux pane ID variable
export tmuxId="$(($(tmux display -pt "${TMUX_PANE:?}" "#{pane_index}") + 1))" 2> /dev/null

# Tons of aliases
alias ip='ip --color'
alias ipb='ip --color --brief'

alias k='kubectl'
alias kx='kubectx'
alias kn='kubens'

alias tx='${HOME}/dotfiles/bin/tsh_switch_cluster.sh'
alias ts='${HOME}/dotfiles/bin/tsh_connect_node.sh'

alias ez="vi ~/.zshrc"
alias ev="vi ~/.vimrc"
alias et="vi ~/.tmux.conf"
alias ek="vi ~/.kube/config"
alias es="vi ~/.config/espanso/default.yml"

alias l='k -ah'
alias fu='sudo $(fc -ln -1)'
alias h='sudo vi /etc/hosts'
alias v='nvim .'
alias t='tmux'
alias st='ssht'
alias i='curl ifconfig.co/ip'
alias c='code .'
alias gw='./gradlew'
alias u='sudo apt-get update && sudo apt-get dist-upgrade -y'

alias gd='git diff --ignore-space-change'
alias git-unreset="git reset 'HEAD@{1}'"
alias git-ssh='git remote set-url origin "$(git remote get-url origin | sed -E '\''s,^https://([^/]*)/(.*)$,git@\1:\2,'\'')"'
alias git-https='git remote set-url origin "$(git remote get-url origin | sed -E '\''s,^git@([^:]*):/*(.*)$,https://\1/\2,'\'')"'
alias gc-='git checkout -'

alias npbr='npm run build && npm run start'

alias ap='ansible-playbook'

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=/home/eliott/.n/bin/:$PATH
export N_PREFIX=$HOME/.n
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/"

export GEM_HOME=~/.ruby/
export PATH="$PATH:~/.ruby/bin"

source <(kubectl completion zsh)
compdef __start_kubectl k

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -f "$HOME/dotfiles/zsh/tsh.zsh" ] && source "$HOME/dotfiles/zsh/tsh.zsh"

source "$HOME/dotfiles/zsh/fzf.zsh"

#eval "$(_DA_CLI_COMPLETE=zsh_source da-cli)"
agility-fortune

#Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

