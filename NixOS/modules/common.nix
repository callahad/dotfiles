{ lib, pkgs, ... }:

{
  imports = [ ./allowedUnfree.nix ];

  # System
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb.options = "ctrl:nocaps";
  console.useXkbConfig = true;

  services.fwupd.enable = true;

  # Nix
  # Version 2.21 has nice ergonomic improvements
  nix.package = if (lib.versionAtLeast pkgs.nix.version "2.21") then pkgs.nix else pkgs.nixVersions.nix_2_21;

  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # By default, NixOS 24.05 pins `nixpkgs` to the same rev that the system used.
  #   Upside: Compatiblity, less duplication in store, faster `nix search`
  #   Downside: Commands like `nix search` appear outdated
  # Not sure if I want this, yet. Uncomment to disable.
  # nixpkgs.flake.setFlakeRegistry = false;
  # nixpkgs.flake.setNixPath = false;

  # Software
  programs.neovim.enable = true;
  programs.neovim = { vimAlias = true; viAlias = true; defaultEditor = true; };

  programs.command-not-found.enable = false;

  environment.systemPackages = with pkgs; [
    # Common
    bc
    curl
    file
    git
    libarchive # bsdtar
    rsync
    tree
    wget
    whois

    # Fancy
    bat
    btop
    eza
    fd
    htop
    ripgrep
    unar

    # Linux-specific
    exfatprogs
    (hunspellWithDicts [ hunspellDicts.en_US ])
    lshw
    lsof
    pciutils
    psmisc
    usbutils
  ];

  # Networking
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = lib.mkForce [ ];
  networking.networkmanager.wifi.backend = "iwd"; # Faster / simpler than wpa_supplicant?
  networking.useDHCP = lib.mkDefault true;

  networking.networkmanager.ethernet.macAddress = "stable";
  networking.networkmanager.wifi.macAddress = "stable-ssid";

  # Reset MAC addresses each boot
  # networking.networkmanager.extraConfig = ''
  #   [connection]
  #   connection.stable-id=''${CONNECTION}-''${BOOT}-''${DEVICE}
  # '';

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";
}
