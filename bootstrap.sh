#!/usr/bin/env bash

apt_install() {
  echo "Installing soft..."
  sudo apt-get update
  sudo apt-get install -y apt-transport-https htop vim mtr locate curl zsh scrot i3lock autojump httpie direnv i3 polybar
}

snap_install() {
  echo "Installing snap..."
  sudo apt-get install snapd
  sudo snap install espanso -y
}

ohmyzsh_install() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

fzf_install() {
  git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
  ${HOME}/.fzf/install --key-bindings --completion --no-update-rc
}

hyperterm_install() {
  which hyper &>/dev/null
  if [[ $? -ne 0 ]]; then
    echo "Hyper install..."
    wget -O hyper.deb https://hyper-updates.now.sh/download/linux_deb
    sudo dpkg -i hyper.deb
    rm hyper.deb
  fi
}

git_install() {
  which git &>/dev/null
  if [[ $? -ne 0 ]]; then
    echo "Git install..."
    sudo apt-get install git -y
  fi

  echo "Dotfiles update..."
  git pull origin master
}

powerline_fonts_install() {
  locate "Ubuntu Mono derivative Powerline" &>/dev/null
  if [[ $? -ne 0 ]]; then
    echo "Install fonts..."
    git clone https://github.com/powerline/fonts.git
    fonts/install.sh
    rm -rf fonts
  fi
}

tmux_install() {
  sudo apt-get install tmux -y
  mkdir ${HOME}/.tmux
  git clone git@github.com:jonmosco/kube-tmux.git ${HOME}/.tmux/kube-tmux
}

link_dotfiles() {
  echo "Linking dotfiles..."
  ln -sf ${HOME}/dotfiles/hyperterm/.hyper.js ${HOME}/.hyper.js
  ln -sf ${HOME}/dotfiles/vim/.vimrc ${HOME}/.vimrc
  ln -sf ${HOME}/dotfiles/zsh/.zshrc ${HOME}/.zshrc
  ln -sf ${HOME}/dotfiles/tmux/.tmux.conf ${HOME}/.tmux.conf
  ln -sf ${HOME}/dotfiles/git/gitconfig ${HOME}/.gitconfig
  ln -sf ${HOME}/dotfiles/polybar/config ${HOME}/.config/polybar/config
  ln -sf ${HOME}/dotfiles/i3/config ${HOME}/.i3/config
  ln -sf ${HOME}/dotfiles/git/gitignore_global ${HOME}/.gitignore_global
  ln -sf ${HOME}/dotfiles/vscode/keybindings.json ${HOME}/.config/Code/User/keybindings.json
  ln -sf ${HOME}/dotfiles/vscode/settings.json ${HOME}/.config/Code/User/settings.json
  ln -sf ${HOME}/dotfiles/ssh/config ${HOME}/.ssh/config
  ln -sf ${HOME}/dotfiles/espanso/default.yml ${HOME}/.config/espanso/default.yml
}

vim_install() {
  echo "Vundle install..."
  git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
}

terminal_theme() {
  git clone https://github.com/Mayccoll/Gogh.git gogh
  ./gogh/themes/elio.sh
  rm -fr gogh
}

kubectl_install() {
  sudo apt-get update && sudo apt-get install -y apt-transport-https
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl
}

vscode_install() {
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg

  sudo apt update
  sudo apt install code

  echo "Install VScode plugins"
  while read -r p; do
    echo "Install $p"
    code --install-extension --force $p
  done <vscode/vscode-plugins
}

main() {
  git_install
  apt_install
  snap_install
  ohmyzsh_install
  fzf_install
  tmux_install
  vscode_install
  powerline_fonts_install
  vim_install
  kubectl_install
  link_dotfiles
}

main
