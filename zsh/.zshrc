# Path to your oh-my-zsh installation.
export ZSH=/home/eliott/.oh-my-zsh

PATH=/home/eliott/.local/bin:$PATH

# ZSH theme
export ZSH_THEME="agnoster"

export REGISTRY_NAME='ci.docapost.io'

eval "$(direnv hook zsh)"

# ZSH plugins
export plugins=(git autojump colorize cp vagrant ansible kubectl)

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

alias ez="vi ~/.zshrc"
alias ev="vi ~/.vimrc"
alias et="vi ~/.tmux.conf"

alias l='k -ah'
alias fu='sudo $(fc -ln -1)'
alias h='sudo vi /etc/hosts'
alias v='vim +:NERDTree'
alias t='tmux'
alias st='ssht'
alias i='curl ifconfig.co/ip'
alias c='vscodium .'
alias gw='./gradlew'
alias u='sudo apt-get update && sudo apt-get dist-upgrade -y'

alias gd='git diff --ignore-space-change'
alias git unreset="git reset 'HEAD@{1}'"
#alias glola='git log --graph --pretty='\'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit --all'
#alias glol='git log --graph --pretty='\'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit'

alias npbr='npm run build && npm run start'

alias ap='ansible-playbook'

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
