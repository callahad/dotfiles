{ config, lib, pkgs, ... }:

let
  inherit (pkgs.hostPlatform) isLinux isDarwin;
  
  commonPackages = with pkgs; [
    caddy
    delta
    gh
    gron
    jq
    tig
  ];

  linuxPackages = with pkgs; [
    # GUI Applications
    calibre
    deluge
    digikam
    gimp
    chromium
    inkscape
    keepassxc
    kitty
    firefox-bin
    libreoffice-fresh
    logseq
    mpv
    noson
    nsxiv
    obsidian
    peek
    quodlibet-full
    rapid-photo-downloader
    simple-scan
    vlc
    
    # Development
    emacs
    gitg

    # Console Utilities
    dua
    ffmpeg-full
    highlight
    oathToolkit
    pdftk
    qpdf
    qrencode
    xclip
    yt-dlp
  ];

  darwinPackages = with pkgs; [
    # I expect these to be installed systemwide on Linux
    bat
    eza
    fd
    git
    tree
    unar
  ];

in

{
  home.stateVersion = "24.05";
  home.language.collate = "C";

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "obsidian"
  ];

  programs.home-manager.enable = true;

  home.packages = commonPackages
    ++ lib.optionals isLinux linuxPackages
    ++ lib.optionals isDarwin darwinPackages;

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ] ++ lib.optionals isDarwin [
    # MacPorts
    "/opt/local/bin"
    "/opt/local/sbin"
  ];

  # Direnv
  programs.direnv.enable = true;

  # Fish
  programs.fish.enable = true;
  programs.fish.shellAliases = {
    ls = "eza --all --classify --group --sort=Name";
    tree = "eza --all --classify --group --sort=Name --tree";
    rm = "rm --interactive=always";
    cat = "bat --style=plain";
  };
  programs.fish.interactiveShellInit = ''
    set -g fish_greeting
    set -x VIRTUAL_ENV_DISABLE_PROMPT 1
    set theme_show_exit_status "yes"
    set fish_key_bindings fish_vi_key_bindings
  '';

  # Helix
  programs.helix.enable = true;
  programs.helix.defaultEditor = true;

  # Less
  programs.lesspipe.enable = true;
  home.sessionVariables."LESS" = lib.concatStringsSep " " [
    "--quit-if-one-screen"
    "--ignore-case" # smartcase
    "--LONG-PROMPT"
    "--RAW-CONTROL-CHARS" # only allows colors
    "--chop-long-lines" # don't softwrap
    "--hilite-unread"
    "--no-init"
    "--window=-4"
  ];

  # Ripgrep
  programs.ripgrep.enable = true;
  programs.ripgrep.arguments = [ "--smart-case" ];

  # SyncThing
  services.syncthing.enable = isLinux;

  # Prevent Wine from generating file associations, desktop links, etc.
  home.sessionVariables."WINEDLLOVERRIDES" = "winemenubuilder.exe=d";

  # Dotfiles
  # NOTE: In many cases, I'd prefer lib.file.mkOutOfStoreSymlink
  # https://github.com/nix-community/home-manager/issues/4692
  xdg.configFile."git".source = ./git;
  xdg.configFile."helix".source = ./helix;
  xdg.configFile."kitty".source = ./kitty;
  xdg.configFile."fish" = { source = ./fish-prompt-metro; recursive = true; };

  home.activation."customActivation" = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
  '';

  # XDG-ification
  # See: https://wiki.archlinux.org/index.php/XDG_Base_Directory
  home.sessionVariables."HISTFILE" = "~/.local/state/bash/history";
  home.file.".local/state/bash/.keep".text = "";
  home.file.".local/share/tig/.keep".text = "";
}
