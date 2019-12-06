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

  # Build sxiv with a patched Imlib2 to support WebP images
  sxiv = super.sxiv.override {
    imlib2 = callPackage ./pkgs/imlib2_webp { };
  };

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
      inkscape
      keepassxc
      kitty
      latest.firefox-nightly-bin
      libreoffice-fresh
      mpv
      nextcloud-client
      peek
      # quodlibet-full # Fails to build, https://github.com/NixOS/nixpkgs/issues/53938
      rapid-photo-downloader
      scribus
      simple-scan
      sxiv
      typora
      vlc
      zoom-us

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
      ffmpeg
      highlight
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
