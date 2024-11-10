# ------------------------------
# General settings
# ------------------------------

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/dotfiles/scripts" ] ; then
    PATH="$HOME/dotfiles/scripts:$PATH"
fi

if [ -d "$HOME/.local/share/mise/shims" ] ; then
    PATH="$HOME/.local/share/mise/shims:$PATH"
fi

for file in ~/.{bash_exports,bash_aliases,bash_options,bash.local}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# ------------------------------
# Functions
# ------------------------------

mkcd(){
    mkdir -p "$1" && cd "$_" || return 1
}

# ------------------------------
# Bash completion
# ------------------------------

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

# Add tab completion for git alias "g" (https://askubuntu.com/a/642778)
if [ -f /usr/share/bash-completion/completions/git ]; then
    source /usr/share/bash-completion/completions/git
    __git_complete g __git_main
fi

# ------------------------------
# History & Prompt
# ------------------------------

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if command -v starship > /dev/null; then
    eval "$(starship init bash)"
fi
