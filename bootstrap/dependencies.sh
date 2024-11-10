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
  if command -v docker >/dev/null; then
    echo "Docker is already installed. You can manage it via apt"
    return
  fi

  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  rm get-docker.sh

  # Post-installation
  sudo groupadd -f docker
  sudo usermod -aG docker "$USER"
  # Activate group changes for current session
  newgrp docker
}

install_mise(){
  dra download -s "mise-v{tag}-linux-arm64-musl" -o ~/.local/bin/mise jdx/mise
  chmod +x ~/.local/bin/mise
}

sudo apt update

sudo apt install -y build-essential \
  curl \
  wget \
  python3-pip \
  python3-dev \
  python3-setuptools \
  pipx \
  vim \
  nodejs

install_dra
install_fzf
install_starship
install_docker
install_mise

setup_pipx

# Cleanup
sudo apt autoremove -y
