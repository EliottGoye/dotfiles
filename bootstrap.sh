#!/usr/bin/env bash

apt_install() {
  echo "Installing soft..."
  sudo apt-get update
  sudo apt-get install -y htop vim mtr locate curl zsh
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
  git clone https://github.com/powerline/fonts.git
  fonts/install.sh
  rm -rf fonts
}

link_dotfiles() {
  echo "Linking dotfiles..."
  ln -sf ~/dotfiles/hyperterm/.hyper.js ~/.hyper.js
  ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
  ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
}

main() {
  apt_install
  git_install
  powerline_fonts_install
  link_dotfiles
}

main
