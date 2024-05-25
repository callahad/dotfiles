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
    # quodlibet-full
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
  # NOTE: Consider using lib.file.mkOutOfStoreSymlink instead of paths
  # Using a raw path copies the contents into the read-only Nix store
  # Using mkOutOfStoreSymlink keeps the source files writable
  # https://github.com/nix-community/home-manager/issues/4692
  xdg.configFile."git".source = ./git;
  xdg.configFile."helix".source = ./helix;
  xdg.configFile."kitty".source = ./kitty;
  xdg.configFile."fish" = { source = ./fish-prompt-metro; recursive = true; };

  xdg.configFile."home-manager".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles";

  # XDG-ification
  # See: https://wiki.archlinux.org/index.php/XDG_Base_Directory
  home.sessionVariables."HISTFILE" = "~/.local/state/bash/history";
  home.file.".local/state/bash/.keep".text = "";
  home.file.".local/share/tig/.keep".text = "";

  # Plasma (via Plasma Manager)
  programs.plasma = {
    enable = true;

    workspace.clickItemTo = "select"; # Plasma 6 default, but not Plasma-Manager

    shortcuts = {
      # Unset conflicting defaults
      "kwin"."Window Quick Tile Top" = [ ];
      "kwin"."Window Quick Tile Bottom" = [ ];
      "plasmashell"."manage activities" = [ ];
      "plasmashell"."activate task manager entry 1" = [ ];
      "plasmashell"."activate task manager entry 2" = [ ];
      "plasmashell"."activate task manager entry 3" = [ ];
      "plasmashell"."activate task manager entry 4" = [ ];
      "plasmashell"."activate task manager entry 5" = [ ];
      "plasmashell"."activate task manager entry 6" = [ ];
      "plasmashell"."activate task manager entry 7" = [ ];
      "plasmashell"."activate task manager entry 8" = [ ];
      "plasmashell"."activate task manager entry 9" = [ ];

      # Set preferred hotkeys
      "kwin"."Switch to Desktop 1" = "Meta+1";
      "kwin"."Switch to Desktop 2" = "Meta+2";
      "kwin"."Switch to Desktop 3" = "Meta+3";
      "kwin"."Switch to Desktop 4" = "Meta+4";
      "kwin"."Switch to Desktop 5" = "Meta+5";
      "kwin"."Switch to Desktop 6" = "Meta+6";
      "kwin"."Switch to Desktop 7" = "Meta+7";
      "kwin"."Switch to Desktop 8" = "Meta+8";
      "kwin"."Switch to Desktop 9" = "Meta+9";

      "kwin"."Window to Desktop 1" = "Meta+!"; # ! -> Shift+1
      "kwin"."Window to Desktop 2" = "Meta+@"; # @ -> Shift+2
      "kwin"."Window to Desktop 3" = "Meta+#"; # ...
      "kwin"."Window to Desktop 4" = "Meta+$";
      "kwin"."Window to Desktop 5" = "Meta+%";
      "kwin"."Window to Desktop 6" = "Meta+^";
      "kwin"."Window to Desktop 7" = "Meta+&";
      "kwin"."Window to Desktop 8" = "Meta+*";
      "kwin"."Window to Desktop 9" = "Meta+(";

      "kwin"."Window Move Center" = "Meta+c";
      "kwin"."Window Maximize" = "Meta+Up";
      "kwin"."Window Minimize" = "Meta+Down";

      "services/kitty.desktop"."_launch" = [ "Meta+Return" ];
    };

    configFile = {
      "dolphinrc"."General"."RememberOpenedTabs".value = false;
      "dolphinrc"."General"."ShowZoomSlider".value = false;
      "klipperrc"."General"."KeepClipboardContents".value = false;
      "systemsettingsrc"."systemsettings_sidebar_mode"."HighlightNonDefaultSettings".value = true;

      "kwinrc"."NightColor"."Active".value = true;
      "kwinrc"."NightColor"."LatitudeAuto".value = 55;
      "kwinrc"."NightColor"."LatitudeFixed".value = 55;
      "kwinrc"."NightColor"."LongitudeAuto".value = "-6";
      "kwinrc"."NightColor"."LongitudeFixed".value = "-6";
      "kwinrc"."NightColor"."Mode".value = "Location";

      "kcminputrc"."[Libinput][2362][628][PIXA3854:00 093A:0274 Touchpad]" = {
        "NaturalScroll".value = true;
        "ClickMethod".value = 2; # Right click by pressing with 2 fingers
      };
    };
  };
}
