set -x EDITOR "vim"

set -x LC_COLLATE "C"

set -x LESS "-F -g -i -M -R -S -w -X -z-4"
if command -v lesspipe.sh > /dev/null
    set -x LESSOPEN "|lesspipe.sh %s"
end

function add_user_path --description='Helper for modifying $PATH'
    for path in $argv
        if test -d $path; and not contains $path $fish_user_paths
            set -g fish_user_paths $fish_user_paths $path
        end
    end
end

# Ruby / Other Local Binaries
add_user_path "$HOME/bin"
add_user_path "$HOME/.local/bin"

# Rust / Cargo
add_user_path "$HOME/.cargo/bin"

# Use OpenSSL headers from Homebrew on macOS. Necessary for compiling Servo:
# https://github.com/sfackler/rust-openssl/issues/255
# https://github.com/servo/servo/issues/7930
if test (uname -s) = 'Darwin'; and type -q brew
    set -l base (brew --prefix openssl)
    if test -d $base
        set -x DEP_OPENSSL_INCLUDE "$base/include"
        set -x OPENSSL_INCLUDE_DIR "$base/include"
    end
end

# Prompt customization
set -x VIRTUAL_ENV_DISABLE_PROMPT 1
set theme_date_format "+%H:%M:%S"
set theme_display_vi "yes"
set theme_display_vi_hide_mode "insert" # Removed from upstream :(
set theme_show_exit_status "yes"

# Disable the "Welcome to fish" message...
set fish_greeting

# Use vi keybinding by default
set fish_key_bindings fish_vi_key_bindings
