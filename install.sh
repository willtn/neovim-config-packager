#!/bin/bash

install_oh_my_fish() {
  echo "Setting up fish..." \
  && chsh -s /usr/bin/fish \
  && rm -rf ~/.config/omf ~/.local/share/omf ~/z.fish ~/.config/fish/functions/nvm.fish \
  && mkdir -p ~/.config/omf \
  && ln -s $(pwd)/init.fish ~/.config/omf/init.fish \
  && ln -s $(pwd)/fish_bundle ~/.config/omf/bundle \
  && curl -fLo ~/z.fish https://raw.githubusercontent.com/sjl/z-fish/master/z.fish \
  && curl -sSL https://raw.githubusercontent.com/brigand/fast-nvm-fish/master/nvm.fish > ~/.config/fish/functions/nvm.fish \
  && tic xterm-256color-italic.terminfo \
  && curl -L https://get.oh-my.fish | fish
}

setup_tmux() {
  echo "Setting up tmux..." \
  && rm -rf ~/.tmux.conf ~/.tmux \
  && ln -s $(pwd)/tmux.conf ~/.tmux.conf \
  && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
  && ~/.tmux/plugins/tpm/bin/install_plugins
}

setup_neovim() {
  echo "Setting up neovim..." \
  && rm -rf ~/.config/nvim ~/.fzf \
  && git clone https://github.com/kristijanhusak/vim-packager.git ~/.config/nvim/pack/packager/opt/vim-packager \
  && ln -s $(pwd)/snippets ~/.config/nvim/snippets \
  && ln -s $(pwd)/init.vim ~/.config/nvim/init.vim \
  && mkdir ~/.config/nvim/backups \
  && nvim -c 'call PackagerInit() | call packager#install({ "on_finish": "UpdateRemotePlugins | qa" })'
}

install_ripgrep() {
  echo "Installing ripgrep..." \
  && rm -f /usr/local/bin/rg \
  && curl -L https://github.com/BurntSushi/ripgrep/releases/download/0.9.0/ripgrep-0.9.0-x86_64-unknown-linux-musl.tar.gz | tar zx \
  && cp ripgrep-0.9.0-x86_64-unknown-linux-musl/rg /usr/local/bin \
  && rm -rf ripgrep-0.9.0-x86_64-unknown-linux-musl
}

install_ctags() {
  local ctags_installed=$(which ctags)
  if [[ -z $ctags_installed ]]; then
    echo "Installing universal ctags..." \
    && rm -rf ./ctags \
    && git clone https://github.com/universal-ctags/ctags \
    && cd ctags && ./autogen.sh && ./configure && make && sudo make install && cd ../ && rm -rf ctags
  fi
}

install_diff_so_fancy() {
  local dif_so_fancy_installed=$(which diff-so-fancy)
  if [[ -z $dif_so_fancy_installed ]]; then
    echo "Installing diff-so-fancy..." \
    && rm -rf /usr/local/bin/diff-so-fancy \
    && curl -fLo /usr/local/bin/diff-so-fancy https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy \
    && git config --global core.pager "diff-so-fancy | less --tabs=4 -R"
  fi
}

echo -n "This will delete all your previous nvim, tmux and zsh settings. Proceed? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
  echo "Installing dependencies..." \
  && sudo apt-get install urlview xdotool dh-autoreconf dconf-cli xsel \
  && setup_tmux \
  && setup_neovim \
  && install_ripgrep \
  && install_ctags \
  && install_diff_so_fancy \
  && install_oh_my_fish
fi
