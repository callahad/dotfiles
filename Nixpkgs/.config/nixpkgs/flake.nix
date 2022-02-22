{
  description = "Personal package set";
  # TODO: Bring back noson, gnomeExtensions.syncthing-icon and patched ranger
  # TODO: Investigate https://github.com/oxalica/rust-overlay, used by Pijul

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-release.url = "github:nixos/nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-release, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:

    let
      # Note: You can set overlays and config as params to import.
      # E.g., pkgs = import nixpkgs { config = { allowUnfree = true; } };
      pkgs = import nixpkgs { inherit system; };
      pkgs-release = import nixpkgs-release { inherit system; };

    in rec {
      packages.my-env = pkgs.buildEnv {
        name = "my-env";
        paths = with pkgs; [
          # GUI Applications
          calibre
          celluloid
          deluge
          pkgs-release.digikam
          flameshot
          gimp
          chromium
          inkscape
          keepassxc
          kitty
          firefox-bin
          libreoffice-fresh
          mpv
          #noson
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
          gron
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
          gsconnect
        ]);
      };

      defaultPackage = packages.my-env;
    });
}
