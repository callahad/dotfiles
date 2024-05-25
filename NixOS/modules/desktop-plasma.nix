{ lib, pkgs, ... }:

{
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.partition-manager.enable = true;

  environment.systemPackages = with pkgs; [ discover ];
}
