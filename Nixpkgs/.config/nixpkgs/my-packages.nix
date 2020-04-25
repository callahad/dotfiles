self: super:

let
  inherit (super) callPackage fetchurl fetchFromGitHub;
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

  # sudo nix-channel --update; nix-env -ir my-env
  my-env = super.buildEnv {
    name = "my-env";
    paths = with self; [
      # GUI Applications
      calibre
      celluloid
      deluge
      digikam breeze-icons # qt5.qtwayland
      flameshot
      gimp
      google-chrome
      imv
      inkscape
      keepassxc
      kitty
      latest.firefox-nightly-bin
      libreoffice-fresh
      mpv
      nextcloud-client
      peek
      quodlibet-full
      rapid-photo-downloader
      scribus
      simple-scan
      typora
      vlc

      # Development
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
      cmus
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

      # Games
      steam-run
    ] ++ (with gnomeExtensions; [
      appindicator
      caffeine
      topicons-plus
      syncthing-icon
      desktop-icons
    ]);
  };
}
