{ pkgs, ... }:

{
  # KDE Plasma Desktop
  config.services.xserver.enable = true;
  config.services.xserver.displayManager.sddm.enable = true;
  config.services.xserver.desktopManager.plasma5.enable = true;

  # Optional hardware support
  config.hardware.bluetooth.enable = true;
  config.networking.networkmanager.enable = true;

  # Additional Packages
  config.environment.systemPackages = with pkgs; [
    #plasma-thunderbolt
    okular
    gwenview
  ];
}
