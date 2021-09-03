#!/usr/bin/env bash

apt_install() {
  echo "Installing soft..."
  sudo apt-get update
  sudo apt-get install -y htop vim mtr locate curl zsh scrot i3lock autojump tmux direnv
}

hyperterm_install() {
  which hyper &> /dev/null
  if [[ $? -ne 0 ]]; then
    echo "Hyper install..."
    wget -O hyper.deb https://hyper-updates.now.sh/download/linux_deb
    sudo dpkg -i hyper.deb
    rm hyper.deb
  fi
}

git_install() {
  which git &> /dev/null
  if [[ $? -ne 0 ]]; then
    echo "Git install..."
    sudo apt-get install git -y
  fi

  echo "Dotfiles update..."
  git pull origin master
}

powerline_fonts_install() {
  locate "Ubuntu Mono derivative Powerline" &> /dev/null
  if [[ $? -ne 0 ]]; then
    echo "Install fonts..."
    git clone https://github.com/powerline/fonts.git
    fonts/install.sh
    rm -rf fonts
  fi
}

tmux_plugin() {
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
}

vim_install() {
  echo "Vundle install..."
  git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
}

main() {
  apt_install
#  hyperterm_install
  git_install
  powerline_fonts_install
  link_dotfiles
  vim_install
  tmux_plugin
}

main
