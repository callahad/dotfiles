{ lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "libsane-dsseries"
  ];

  # Software
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];

  services.flatpak.enable = true;

  environment.variables = {
    # Disable Firefox 67's profile-per-install feature (breaks on NixOS)
    #   https://github.com/mozilla/nixpkgs-mozilla/issues/163
    MOZ_LEGACY_PROFILES = "1";

    # Make Firefox scroll better in Xorg
    MOZ_USE_XINPUT2 = "1";

    # Prefer Wayland in Chromium and Electron apps
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    clinfo
    glxinfo
    vulkan-tools
    wayland-utils
  ];

  # Fonts
  fonts.fontconfig.allowBitmaps = false;
  fonts.enableDefaultPackages = false;
  fonts.packages = with pkgs; [
    dejavu_fonts
    iosevka-bin
    noto-fonts-color-emoji
  ];

  # Mouse
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # Scanner
  hardware.sane.enable = true;
  hardware.sane.dsseries.enable = true;

  # Printer
  services.printing.enable = true;
  # services.printing.drivers = [ pkgs.brlaser ]; # IPP Everywhere seems fine?

  # Discovery fails with systemd-resolved; use Avahi for mDNS / DNS-SD.
  # https://github.com/apple/cups/issues/5452
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.resolved.enable = false;
}
