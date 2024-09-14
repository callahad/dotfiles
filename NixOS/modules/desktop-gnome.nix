{ lib, pkgs, ... }:

{
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
    gnome-connections
    gnome-logs
    gnome-maps
    gnome-music
    gnome-photos
    gnome-tour
    orca
  ];

  environment.systemPackages = with pkgs; [
    dconf-editor
    gnome-tweaks
  ];
}
