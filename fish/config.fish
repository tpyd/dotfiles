set -gx EDITOR /opt/nvim-linux-x86_64/bin/nvim
set fish_greeting

# Explicitly add paths to avoid tmux $PATH shenanigans
fish_add_path --path $HOME/.cargo/bin
fish_add_path --path $HOME/.local/bin

