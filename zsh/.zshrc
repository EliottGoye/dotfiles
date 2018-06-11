# Path to your oh-my-zsh installation.
export ZSH=/home/eliott/.oh-my-zsh

# ZSH theme
ZSH_THEME="agnoster"

# ZSH plugins
plugins=(git autojump colorize cp fast k vagrant ansible)

source $ZSH/oh-my-zsh.sh

# Short prompt
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
  fi
}

# Tmux pane ID variable
export tmuxId="$(($(tmux display -pt "${TMUX_PANE:?}" "#{pane_index}") + 1))" 2> /dev/null

# Tons of aliases
alias ip='ip --color'
alias ipb='ip --color --brief'

alias ez="vi ~/.zshrc"
alias ev="vi ~/.vimrc"
alias et="vi ~/.tmux.conf"

alias l='k -ah'
alias fu='sudo $(fc -ln -1)'
alias h='sudo vi /etc/hosts'
alias v='vim +:NERDTree'
alias t='tmux'
alias i='curl ifconfig.co/ip'
alias c='code .'
alias gw='./gradlew'
alias u='sudo apt-get update && sudo apt-get dist-upgrade -y'


# SSH auto-completion
h=()
if [[ -r ~/.ssh/config ]]; then
  h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
if [[ -r ~/.ssh/known_hosts ]]; then
  h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
fi
if [[ $#h -gt 0 ]]; then
  zstyle ':completion:*:ssh:*' hosts $h
  zstyle ':completion:*:slogin:*' hosts $h
fi

