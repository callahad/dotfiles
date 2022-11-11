{
  description = "Personal package set";
  # TODO: Bring back noson, gnomeExtensions.syncthing-icon and patched ranger
  # TODO: Investigate https://github.com/oxalica/rust-overlay, used by Pijul

  # To use:
  #   nix flake update path:.
  #   nix profile install path:.
  #   nix profile upgrade '.*'

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-release.url = "github:nixos/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-release, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:

    let
      # Note: You can set overlays and config as params to import.
      # E.g., pkgs = import nixpkgs { config = { allowUnfree = true; } };
      pkgs = import nixpkgs {
        inherit system;
        config = {
          chromium.commandLineArgs = "--ozone-platform-hint=auto";
          allowUnfreePredicate = pkg:
            builtins.elem (pkg.pname or (builtins.parseDrvName(pkg.name).name))
              [ "obsidian" ];
        };
      };
      pkgs-release = import nixpkgs-release { inherit system; };
      ranger = pkgs.ranger.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          ./pkgs/ranger.patch
        ];
      });

    in rec {
      packages.my-env = pkgs.buildEnv {
        name = "my-env";
        paths = with pkgs; [
          # GUI Applications
          #calibre - was failing to build with qtwebengine
          celluloid
          deluge
          pkgs-release.digikam
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
          nsxiv
          obsidian
          peek
          quodlibet-full
          rapid-photo-downloader
          simple-scan
          vlc

          # Development
          delta
          devd
          docker-compose
          emacsNativeComp
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
          (neovim.override { vimAlias = true; viAlias = true; })
          oathToolkit
          pdftk
          qpdf
          qrencode
          ranger poppler_utils ffmpegthumbnailer imagemagick fontforge sqlite
          stow
          syncthing
          xclip
          yt-dlp aria
        ] ++ (with gnomeExtensions; [
          appindicator
          caffeine
          gsconnect
        ]);
      };

      defaultPackage = packages.my-env;
    });
}
