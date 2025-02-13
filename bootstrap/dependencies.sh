#!/usr/bin/env bash

set -euo pipefail

DRA="/usr/local/bin/dra"
MISE="$HOME/.local/bin/mise"

# https://github.com/devmatteini/dra
install_dra(){
  curl --proto '=https' \
    --tlsv1.2 \
    -sSf https://raw.githubusercontent.com/devmatteini/dra/refs/heads/main/install.sh | \
    bash -s -- --to "$DRA"

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
  [ ! -d ~/.fzf ] && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || git -C ~/.fzf pull
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
  "$DRA" download -s "mise-v{tag}-linux-arm64-musl" -i -o "$MISE" jdx/mise
}

install_nodejs(){
  "$MISE" install node@20 node@22
  "$MISE" use -g node@22
}

install_caddy(){
  # https://caddyserver.com/docs/install#debian-ubuntu-raspbian
  sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
  sudo apt update
  sudo apt install -y caddy
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
install_mise
install_nodejs
install_caddy

setup_pipx

# Cleanup
sudo apt autoremove -y
