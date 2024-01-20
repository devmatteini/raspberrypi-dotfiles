#!/usr/bin/env bash

set -euo pipefail

DRA="/usr/local/bin/dra"

# https://github.com/devmatteini/dra
install_dra(){
  TMP_DIR=$(mktemp --directory)
  ARCHIVE="$TMP_DIR/dra.tar.gz"

  # Download latest linux musl release asset (https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8)
  curl -s https://api.github.com/repos/devmatteini/dra/releases/latest \
  | grep "browser_download_url.*aarch64-unknown-linux-gnu" \
  | cut -d : -f 2,3 \
  | tr -d \" \
  | wget -O "$ARCHIVE" -i -

  # Extract archive and move binary to home directory
  tar xf "$ARCHIVE" --strip-components=1 -C "$TMP_DIR"
  sudo mv "$TMP_DIR"/dra "$DRA"

  # Post installation setup
  "$DRA" completion bash >"$HOME"/.local/share/bash-completion/completions/dra
}

setup_vim(){
  mkdir -p ~/.vim ~/.vim/autoload ~/.vim/backup ~/.vim/colors ~/.vim/plugged

  # Install vim-plug (https://github.com/junegunn/vim-plug)
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # Install plugins (https://github.com/junegunn/vim-plug/issues/675#issuecomment-328157169)
  vim +'PlugInstall --sync' +qa
}

setup_pipx(){
  local python_argcomplete=""
  if command -v register-python-argcomplete3 > /dev/null; then
      python_argcomplete="register-python-argcomplete3"
  elif command -v register-python-argcomplete > /dev/null; then
      python_argcomplete="register-python-argcomplete"
  else
    echo "Cannot find 'register-python-argcomplete', skipping setup_pipx"
    return
  fi

  "$python_argcomplete" pipx >"$HOME"/.local/share/bash-completion/completions/pipx 
}

install_starship(){
  "$DRA" download -s starship-aarch64-unknown-linux-musl.tar.gz -i -o ~/.local/bin starship/starship
}

install_fzf(){
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --key-bindings --completion --no-update-rc
}

install_docker(){
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  rm get-docker.sh

  # Post-installation
  sudo groupadd docker
  sudo usermod -aG docker "$USER"
  # Activate group changes for current session
  newgrp docker
}

sudo apt update

sudo apt install -y build-essential \
  curl \
  wget \
  python3-pip \
  python3-dev \
  python3-setuptools \
  pipx \
  vim

install_dra
install_fzf
install_starship
install_docker

setup_pipx
setup_vim

# Cleanup
sudo apt autoremove -y
