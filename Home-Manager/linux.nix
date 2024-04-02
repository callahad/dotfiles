{ config, pkgs, ...}:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "obsidian"
  ];

  services.syncthing.enable = true;

  home.packages = with pkgs; [
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
}
