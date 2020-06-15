#!/usr/bin/env bash
install_oh_my_zsh() {
  echo "Setting up zsh..." \
  && rm -rf ~/.zshrc ~/.oh-my-zsh ~/.antigen \
  && ln -s $(pwd)/zsh/zshrc ~/.zshrc \
  && git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
  && mkdir ~/.antigen \
  && curl -L git.io/antigen > ~/.antigen/antigen.zsh \
  && chsh -s /bin/zsh
}

install_neovim() {
  echo "Setting up neovim..." \
  && rm -rf ~/.config/nvim $(pwd)/nvim/pack ~/.fzf \
  && ln -s $(pwd)/nvim ~/.config/nvim \
  && git clone https://github.com/kristijanhusak/vim-packager.git ~/.config/nvim/pack/packager/opt/vim-packager \
  && nvim -c 'PackagerInstall'
}

install_ripgrep() {
  echo "Installing ripgrep..." \
  && sudo rm -f /usr/local/bin/rg \
  && curl -L https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep-0.10.0-x86_64-unknown-linux-musl.tar.gz | tar zx \
  && sudo cp ripgrep-0.10.0-x86_64-unknown-linux-musl/rg /usr/local/bin \
  && rm -rf ripgrep-0.10.0-x86_64-unknown-linux-musl
}

install_ctags() {
  echo "Installing universal ctags..." \
    && rm -f ~/.ctags \
    && sudo apt-get install -y exuberant-ctags \
    && ln -s $(pwd)/ctags/ctags ~/.ctags
}

install_diff_so_fancy() {
  echo "Installing diff-so-fancy..." \
    && npm install -g diff-so-fancy \
    && git config --global core.pager "diff-so-fancy | less --tabs=4 -R"
}

install_alacritty() {
  echo "Installing alacritty..." \
    && rm -rf ~/.config/alacritty \
    && xdg-open "https://github.com/alacritty/alacritty/releases" \
    && ln -s $(pwd)/alacritty ~/.config/alacritty
}

install_git() {
  echo "Installing git..." \
    && rm -rf ~/.config/git \
    && sudo apt-get install -y git \
    && ln -s $(pwd)/git ~/.config/git
}

install_tmux() {
  echo "Installing tmux..." \
  && rm -rf ~/.tmux ~/.tmux.conf ~/.tmux.conf.local \
  && sudo apt-get install -y tmux \
  && ln -s $(pwd)/tmux/.tmux.conf ~/.tmux.conf \
  && ln -s $(pwd)/tmux/.tmux.conf.local ~/.tmux.conf.local \
  && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

if [[ -z "$1" ]]; then
  echo -n "This will delete all your previous nvim, zsh settings. Proceed? (y/n)? "
  read answer
  if echo "$answer" | grep -iq "^y" ;then
    echo "Installing dependencies..." \
    && install_git \
    && install_oh_my_zsh \
    && install_neovim \
    && install_ripgrep \
    && install_ctags \
    && install_diff_so_fancy \
    && install_alacritty \
    && install_tmux \
    && echo "Finished installation."
  fi
else
  "install_$1" $1
fi
