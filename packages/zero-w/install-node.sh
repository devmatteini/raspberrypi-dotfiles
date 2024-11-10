#!/usr/bin/env bash

version="v18.9.1"
node_url="https://unofficial-builds.nodejs.org/download/release/${version}/node-${version}-linux-armv6l.tar.gz"

node_path="$HOME/.local/share/node/$version"
node_bin_dir="$HOME/.local/bin"
mkdir -p "$node_path"
mkdir -p "$node_bin_dir"

temp_file=$(mktemp)
echo "Downloading node to $temp_file"
curl "$node_url" -o "$temp_file"

echo "Extracting node to $node_path"
tar xf "$temp_file" --strip-components=1 -C "$node_path"

ln -sf "$node_path/bin/node" "$node_bin_dir/node"
sudo ln -sf "$node_path/bin/node" /usr/local/bin/node

echo "Setup completed. Node version:"
"$node_bin_dir/node" --version
