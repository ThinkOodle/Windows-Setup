#!/usr/bin/env sh
#
# Installs homebrew, gets all dotfiles from the repo,
# installs oh-my-zsh, and executes the setup script for the dotfiles

# cd "$(dirname "$0")/.."
# DOTFILES_ROOT=$(pwd)
DOTZSH=$HOME/.dotfiles

if [ -t 1 ]; then
exec zsh
fi

set -e

echo ''

info () {
  printf "  [ \033[00;34m..\033[0m ] $1"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

setup_gitconfig () {
  if ! [ -f $DOTZSH/git/gitconfig.symlink ]
  then
    info 'setup gitconfig'

    git_credential='cache'
    if [ "$(uname -s)" == "Darwin" ]
    then
      git_credential='osxkeychain'
    fi

    user ' - What is your git author name?'
    read -e git_authorname
    user ' - What is your git author email?'
    read -e git_authoremail

    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" $DOTZSH/git/gitconfig.symlink.example > $DOTZSH/git/gitconfig.symlink

    success 'gitconfig'
  fi
}


link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

install_dotfiles () {
  info 'installing dotfiles'

  local overwrite_all=false backup_all=true skip_all=false

  for src in $(find -H "$DOTZSH" -maxdepth 2 -name '*.symlink')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}

if [ -d "$HOME/.oh-my-zsh" ]; then
  user "File already exists for .oh-my-zsh, what do you want to do?\n\
  [s]kip installation, [b]ackup and continue?"
  read -n 1 action

  case "$action" in
    b )
      backup=true;;
    s )
      skip=true;;
    * )
      backup=true;;
  esac
  echo $action

  if [ "$skip" != "true" ] && [ "$backup" == "true" ]; then
    echo "Backing up Oh-My-Zsh..."
    mv $HOME/.oh-my-zsh $HOME/.oh-my-zsh.backup

    echo "Installing Oh-My-Zsh..."
    curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
  else
    echo "Skipping Oh-My-Zsh installation"
  fi
else
  echo "Installing Oh-My-Zsh..."
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
fi

if [ -d "$HOME/.dotfiles" ]; then
  user "File already exists for .dotfiles, what do you want to do?\n\
  [s]kip installation, [b]ackup and continue?"
  read -n 1 action

  case "$action" in
    b )
      backup=true;;
    s )
      skip=true;;
    * )
      backup=true;;
  esac

  if [ "$skip" != "true" ] && [ "$backup" == "true" ]; then
    echo "Installing Dotfiles..."

    if [ -d "$HOME/.dotfiles" ]; then
      mv $HOME/.dotfiles $HOME/.dotfiles.backup
    fi

    git clone https://github.com/ThinkOodle/wsl-dotfiles.git ~/.dotfiles
    setup_gitconfig
    install_dotfiles

  else
    echo "Skipping Dotfile installation"
  fi

else
  echo "Installing Dotfiles..."
  git clone https://github.com/ThinkOodle/wsl-dotfiles.git ~/.dotfiles
  setup_gitconfig
  install_dotfiles
fi

echo ''
success '  All installed!'
echo ''
