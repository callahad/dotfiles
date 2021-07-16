self: super:

let
  inherit (super) callPackage fetchurl fetchFromGitHub libsForQt5;
in

{
  # Gnome Extensions
  gnomeExtensions = super.gnomeExtensions // {
    syncthing-icon = callPackage ./pkgs/gnomeExtensions/syncthing-icon.nix { };
    desktop-icons = callPackage ./pkgs/gnomeExtensions/desktop-icons.nix { };
  };

  ranger = super.ranger.overrideAttrs(oldAttrs: {
    patches = (oldAttrs.patches or []) ++ [
      ./pkgs/ranger.patch
    ];
  });

  noson = libsForQt5.callPackage ./pkgs/noson.nix { };

  # sudo nix-channel --update; nix-env -ir my-env
  my-env = super.buildEnv {
    name = "my-env";
    paths = with self; [
      # GUI Applications
      calibre
      celluloid
      deluge
      digikam
      flameshot
      gimp
      google-chrome
      inkscape
      keepassxc
      kitty
      latest.firefox-beta-bin
      libreoffice-fresh
      mpv
      noson
      nextcloud-client
      peek
      quodlibet-full
      rapid-photo-downloader
      simple-scan
      sxiv
      vlc

      # Development
      delta
      devd
      docker_compose
      emacs
      gitAndTools.gitSVN
      gitAndTools.hub
      gitAndTools.tig
      gitg
      jq
      mercurial

      # Console Utilities
      dua
      ffmpeg-full
      highlight
      ncdu
      oathToolkit
      pdftk
      qpdf
      qrencode
      ranger poppler_utils ffmpegthumbnailer imagemagick fontforge sqlite
      stow
      syncthing
      xclip
      youtube-dl aria
    ] ++ (with gnomeExtensions; [
      appindicator
      caffeine
      topicons-plus
      syncthing-icon
      desktop-icons
    ]);
  };
}
