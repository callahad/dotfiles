{ config, lib, pkgs, ... }:

let
  inherit (pkgs.hostPlatform) isLinux isDarwin;
  
  commonPackages = with pkgs; [
    caddy
    delta
    gh
    gron
    helix
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
    yt-dlp aria
  ];

  darwinPackages = with pkgs; [
    # I expect these to be installed systemwide on Linux
    bat
    eza
    fd
    git
    ripgrep
    tree
    unar
  ];

in

{
  home.stateVersion = "24.05";

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "obsidian"
  ];

  programs.home-manager.enable = true;

  services.syncthing.enable = isLinux;

  home.packages = commonPackages
    ++ lib.optionals isLinux linuxPackages
    ++ lib.optionals isDarwin darwinPackages;
}
