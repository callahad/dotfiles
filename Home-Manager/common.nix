{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    caddy
    delta
    gh
    gitAndTools.tig
    gron
    helix
    jq
  ];
}
