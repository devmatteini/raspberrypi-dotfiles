#!/usr/bin/env bash

if [ -z "$1" ];then
    echo "Usage: $(basename "${BASH_SOURCE[0]}") <BASEDIR>"
    exit 1
fi

BASEDIR=$1

# $1 = source_file, $2 = target_file
create_symlink() {
    local source_file=$1
    local target_file=$2

    if [[ $DEBUG != "true" ]]; then
        ln -sfn "$source_file" "$target_file"
    else
        echo "$source_file -> $target_file"
    fi
}

# $1 = source_directory, $2 = target_directory
symlink_dir_files() {
    local directory=$1
    local target_directory=$2
    local full_path="$BASEDIR/$directory"

    echo -e "\e[1;34m[i] Creating symlinks for '$directory' in '$target_directory'\e[0m"

    readarray -t DIR_FILES < <(find "$full_path" -maxdepth 1 -type f)
    
    for file in "${DIR_FILES[@]}"; do
        filename=$(basename "$file")

        source_file=$file
        target_file="$target_directory/$filename"

        create_symlink "$source_file" "$target_file"
    done
}

symlink_dir_files "bash" "$HOME"
symlink_dir_files "vim" "$HOME"
symlink_dir_files "config" "$HOME/.config"

echo -e "\e[1;32m[✓] Symlinks created succesfully.\e[0m"
