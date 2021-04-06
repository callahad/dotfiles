# Set up Nix on macOS
if [ -f '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]
    fenv source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
end

# Stay in Fish after calling `nix-shell` or `nix run`
any-nix-shell fish --info-right | source

if type -q nvim
    set -x EDITOR "nvim"
else
    set -x EDITOR "vim"
end

set -x LC_COLLATE "C"

set -x LESS "-F -g -i -M -R -S -w -X -z-4"
if command -v lesspipe.sh > /dev/null
    set -x LESSOPEN "|lesspipe.sh %s"
end

# XDG-ification
# See: https://wiki.archlinux.org/index.php/XDG_Base_Directory
# Create XDG_DATA_DIRs that we might need
for name in less bash tig
    [ -d ~/.local/share/$name ]; or mkdir -p ~/.local/share/$name
end; set -e name

set -x LESSHISTFILE "$HOME/.local/share/less/history"
set -x HISTFILE "$HOME/.local/share/bash/history"

# Prevent Wine from generating file associations, desktop links, etc.
set -x WINEDLLOVERRIDES "winemenubuilder.exe=d"

# Ruby / Other Local Binaries
fish_add_path "$HOME/bin"
fish_add_path "$HOME/.local/bin"

# Rust / Cargo
fish_add_path "$HOME/.cargo/bin"

# Prompt customization
set -x VIRTUAL_ENV_DISABLE_PROMPT 1
set theme_show_exit_status "yes"

# Disable the "Welcome to fish" message...
set -U fish_greeting

# Use vi keybinding by default
set fish_key_bindings fish_vi_key_bindings
