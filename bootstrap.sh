#!/usr/bin/env bash

apt_install() {
  echo "Installing soft..."
  sudo apt-get update
  sudo apt-get install -y htop vim mtr locate curl zsh scrot i3lock autojump tmux
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

link_dotfiles() {
  echo "Linking dotfiles..."
  ln -sf ~/dotfiles/hyperterm/.hyper.js ~/.hyper.js
  ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
  ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
  ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
  ln -sf ~/dotfiles/git/gitconfig ~/.gitconfig
  ln -sf ~/dotfiles/polybar/config ~/.config/polybar/config
  ln -sf ~/dotfiles/i3/config ~/.i3/config
  ln -sf ~/dotfiles/git/gitignore_global ~/.gitignore_global
	ln -sf ~/dotfiles/vscode/keybindings.json ~/.config/Code/User/keybindings.json
	ln -sf ~/dotfiles/vscode/settings.json ~/.config/Code/User/settings.json
	ln -sf ~/dotfiles/ssh/config ~/.ssh/config
}

vim_install() {
  echo "Vundle install..."
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
}

main() {
  apt_install
#  hyperterm_install
  git_install
  powerline_fonts_install
  link_dotfiles
  vim_install
}

main
