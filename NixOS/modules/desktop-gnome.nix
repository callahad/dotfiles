{ lib, pkgs, ... }:

{
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.desktopManager.gnome.extraGSettingsOverridePackages = [ pkgs.mutter ];
  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.mutter]
    experimental-features=['variable-refresh-rate', 'scale-monitor-framebuffer']
  '';

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
  ] ++ (with pkgs.gnomeExtensions; [
    appindicator
    caffeine
    gtk4-desktop-icons-ng-ding
    syncthing-indicator
  ]);
}
