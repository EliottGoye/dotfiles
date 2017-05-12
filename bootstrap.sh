#!/usr/bin/env bash

git_install() {
  if which git &> /dev/null -ne 0; then
    echo "Git install..."
    sudo apt-get update
    sudo apt-get install git -y
  fi

  echo "Dotfiles update"
  git pull origin master
}

link_dotfiles() {
  echo "Linking dotfiles"
  ln -sf ~/dotfiles/hyperterm/.hyper.js ~/.hyper.js
  ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
  ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
}

main() {
  git_install
  link_dotfiles
}

main
