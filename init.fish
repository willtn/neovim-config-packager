set fish_greeting
set -U fish_prompt_pwd_dir_length 0
set -x EDITOR 'nvim'
set -x LESS 'R'
set -x MANPAGER "nvim -c 'set ft=man' -"
set -x FZF_DEFAULT_COMMAND 'rg --files'
set -gx PATH ~/go/bin $PATH
nvm use 8.7.0
alias n='nvim .'
alias install='sudo apt-get install'
alias search='sudo apt-cache search'
alias purge='sudo apt-get purge'
alias update='sudo apt-get purge'
alias c7="sudo chmod -R 777"
alias l="ls -l"
alias c="clear"
alias www="cd /var/www"
alias weather="curl http://wttr.in/Novi sad"
alias gs="git status"
alias code="cd ~/code"
alias lg="lazygit"
alias dco="docker-compose"
alias dcup="docker-compose up"

if status is-interactive
and not set -q TMUX
    exec tmux
end

if test -e ~/z.fish
  . ~/z.fish
end

if test -e ~/.fish_secret
  . ~/.fish_secret
end
