{ lib, pkgs, ... }:

{
  allowedUnfree = [ "steam" "steam-unwrapped" ];

  programs.steam.enable = true;
  programs.gamescope.enable = true;
  # programs.gamescope.capSysNice = true;
  # programs.steam.extest.enable = true;
  # programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin ];
  # programs.steam.remotePlay.openFirewall = true;
  # programs.steam.localNetworkGameTransfers.openFirewall = true;
  # programs.steam.gamescopeSession.enable = true;
}
