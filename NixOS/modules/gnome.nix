{ pkgs, ... }:

{
  # GNOME Desktop
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # ...Remove GNOME packages I don't want
  environment.gnome.excludePackages = with pkgs.gnome; [
    epiphany
    pkgs.gnome-connections
    gnome-logs
    gnome-maps
    gnome-music
    pkgs.gnome-photos
  ];
  programs.geary.enable = false;

  # ...Add GNOME packages I do want
  environment.systemPackages = with pkgs.gnome; [
    dconf-editor
    gnome-tweaks
  ];
}
