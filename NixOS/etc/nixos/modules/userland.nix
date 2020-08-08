{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Package Overrides
  nixpkgs.config.packageOverrides = pkgs: {
    # Alias vi and vim to neovim
    neovim = pkgs.neovim.override { vimAlias = true; viAlias = true; };

    # Temporary hack to work around https://github.com/fish-shell/fish-shell/issues/6994
    fish = pkgs.fish.overrideAttrs(oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [
        ./fish-kitty-images.patch
      ];
    });
  };

  # Software
  environment.systemPackages = with pkgs; [
    # Basic Console Utilities
    bc
    bind.dnsutils # dig, nslookup, ...
    bind.host
    curl
    file
    git
    lesspipe
    lsof
    psmisc # pstree, killall, ...
    rsync
    tree
    wget
    which
    whois

    # Linux-Specific Utilities
    efibootmgr
    exfat
    lshw
    pciutils
    powertop
    thunderbolt
    usbutils # lsusb

    # Enhanced Console Utilities
    bat
    exa
    fd
    fish any-nix-shell
    htop
    neovim
    ripgrep

    # Archives
    libarchive # bsdtar
    unar

    # Backup
    borgbackup
    restic

    # Other
    ispell
    hunspellDicts.en-us
  ];

  # GnuPG (GPG)
  programs.gnupg.agent.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # Environment Variables
  environment.variables = {
    # Make neovim the defualt editor
    EDITOR = pkgs.lib.mkForce "nvim";

    # Disable Firefox 67's profile-per-install feature (breaks on NixOS)
    #   https://github.com/mozilla/nixpkgs-mozilla/issues/163
    MOZ_LEGACY_PROFILES="1";

    # Make Firefox scroll better in Xorg
    MOZ_USE_XINPUT2="1";
  };
}
