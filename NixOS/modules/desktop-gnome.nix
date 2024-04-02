{ lib, pkgs, ... }:

{
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs.gnome; [
    epiphany
    geary
    gnome-logs
    gnome-maps
    gnome-music
    pkgs.gnome-connections
    pkgs.gnome-photos
    pkgs.gnome-tour
    pkgs.orca
  ];

  environment.systemPackages = with pkgs.gnome; [
    dconf-editor
    gnome-tweaks
  ];
}
